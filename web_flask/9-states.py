#!/usr/bin/python3
'''A simple Flask web app.
'''
from flask import Flask, render_template
from models import storage
from models.state import State


app = Flask(__name__)
app.url_map.strict_slashes = False


@app.route('/states')
@app.route('/states/<id>')
def list_states(id=None):
    '''states page.'''
    states = None
    state = None
    all_states = list(storage.all(State).values())
    case = 404
    if id is not None:
        match = list(filter(lambda y: y.id == id, all_states))
        if len(match) > 0:
            state = match[0]
            state.cities.sort(key=lambda y: y.name)
            case = 2
    else:
        states = all_states
        for state in states:
            state.cities.sort(key=lambda y: y.name)
        states.sort(key=lambda y: y.name)
        case = 1
    vars = {
        'states': states,
        'state': state,
        'case': case
    }
    return render_template('9-states.html', **vars)


@app.teardown_appcontext
def flask_app_teardown(exec):
    '''tear down'''
    storage.close()


if __name__ == '__main__':
    app.run(host='0.0.0.0', port='5000')
