#!/usr/bin/python3
""" Fabric script that distributes an archive to web servers """
from fabric.api import *
from datetime import datetime
import os

env.hosts = ["18.233.63.216", "100.26.173.67"]
env.user = "ubuntu"


def do_pack():
    """Function that generates a .tgz archive from the contents of the
    web_static folder

    Returns:
        str: the archive path if the archive has been correctly generated
    """
    if not os.path.isdir("versions"):
        if local("mkdir versions").failed:
            return None
    date = datetime.now().strftime("%Y%m%d%H%M%S")
    file = "versions/web_static_{}.tgz".format(date)
    try:
        print("Packing web_static to {}".format(file))
        local("tar -cvzf {} web_static".format(file))
        print("web_static packed: {} -> {}Bytes".format(
            file,
            os.path.getsize(file)
        )
        )
    except Exception:
        return None
    return file


def do_deploy(archive_path):
    """Function that distributes an archive to web servers

    Args:
        archive_path (str): path to the archive

    Returns:
        bool: True if all operations have been done correctly, False otherwise
    """
    if not os.path.exists(archive_path):
        return False
    res = []
    try:
        result = put(archive_path, '/tmp/')
        res.append(result.succeeded)
        archive = archive_path.split('/')[-1]
        archive_name = archive.split('.')[0]
        run('mkdir -p /data/web_static/releases/{}/'.format(archive_name))
        run('tar -xzf /tmp/{} -C /data/web_static/releases/{}/'.format(
            archive,
            archive_name))
        run('rm /tmp/{}'.format(archive))
        run('mv /data/web_static/releases/{0}/web_static/* \
/data/web_static/releases/{0}/'.format(archive_name))
        run('rm -rf /data/web_static/releases/{}/web_static'.format(
            archive_name))
        run('rm -rf /data/web_static/current')
        run('ln -s /data/web_static/releases/{}/ \
/data/web_static/current'.format(archive_name))
        print("New version deployed!")
        return True
    except Exception:
        return False
