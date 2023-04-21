#!/usr/bin/python3
"""Web app with flask
"""
from flask import Flask, escape


app = Flask(__name__)
app.url_map.strict_slashes = False


@app.route('/')
def hello():
    """The home page"""
    return "Hello HBNB!"


@app.route('/hbnb')
def hbnb():
    """The HBNB home page"""
    return "HBNB"


@app.route('/c/<text>')
def c_text(text):
    """The c page"""
    return "C {}".format(escape(text.replace('_', ' ')))


@app.route('/python/<text>')
@app.route('/python', defaults={'text': 'is cool'})
def pyhton_text(text):
    """The python page."""
    return 'Python {}'.format(escape(text.replace('_', ' ')))


if __name__ == '__main__':
    app.run(host='0.0.0.0', port='5000')
