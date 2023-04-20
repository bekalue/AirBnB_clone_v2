#!/usr/bin/python3
"""Web app with flask
"""
from flask import Flask


app = Flask(__name__)
app.url_map.strict_slashes = False


@app.route('/')
def hello():
    """The home page"""
    return 'Hello HBNB!'


@app.route('/hbnb')
def hbnb():
    """The HBNB page"""
    return "HBNB"


if __name__ == '__main__':
    app.run(host='0.0.0.0', port='5000')
