#!/usr/bin/python3
"""A simple flask web app.
"""
from flask import Flask, render_template

from models import storage
from models.state import State


app = Flask(__name__)
app.url_map.strict_slashes = False


@app.route('/states')
@app.route('/states/<id>')
def states(id=None):
    """The page to display states"""
    state = None
    states = None
    all_states = list(storage.all(State).values())
    case = 404
    if id:
        match = list(filter(lambda x: x.id == id, all_states))
        if len(match) > 0:
            state = match[0]
            state.cities.sort(key=lambda x: x.name)
            case = 1
    elif id is None:
        case = 2
        states = all_states
        states.sort(key=lambda y: y.name)
        for state in states:
            state.cities.sort(key=lambda y: y.name)
    vars = {
            'states': states,
            'state': state,
            'case': case
            }
    return render_template('9-states.html', **vars)


@app.teardown_appcontext
def teardown_flask_app(exec):
    """tear down"""
    storage.close()


if __name__ == '__main__':
    app.run(host='0.0.0.0', port='5000')
