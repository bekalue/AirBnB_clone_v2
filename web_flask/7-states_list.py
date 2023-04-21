#!/usr/bin/python3
'''A simple flask web app.
'''
from flask import Flask, render_template

from models import storage
from models.state import State


app = Flask(__name__)
app.url_map.strict_slashes = False


@app.route('/states_list')
def list_states():
    """To list all states in a page"""
    states = list(storage.all(State).values())
    states.sort(key=lambda y: y.name)
    vars = {
            'states': states
            }
    return render_template('7-states_list.html', **vars)


@app.teardown_appcontext
def teardown_flask_app(exec):
    """tear down the app"""
    storage.close()


if __name__ == '__main__':
    app.run(host='0.0.0.0', port='5000')
