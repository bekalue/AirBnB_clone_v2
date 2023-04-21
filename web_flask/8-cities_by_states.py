#!/usr/bin/python3
'''A simple flask web app
'''
from flask import Flask, render_template

from models import storage
from models.state import State


app = Flask(__name__)
app.url_map.strict_slashes = False


@app.route('/cities_by_states')
def cities_by_states():
    """To list cities by states on page"""
    states = list(storage.all(State).values())
    states.sort(key=lambda y: y.name)
    for state in states:
        state.cities.sort(key=lambda y: y.name)
    vars = {
            'states': states
            }
    return render_template('8-cities_by_states.html', **vars)


@app.teardown_appcontext
def flask_teardown(exec):
    """tear down"""
    storage.close()


if __name__ == '__main__':
    app.run(host='0.0.0.0', port='5000')
