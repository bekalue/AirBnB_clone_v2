#!/usr/bin/python3
'''A simple Flask web app.
'''
from flask import Flask, render_template, Markup

from models import storage
from models.amenity import Amenity
from models.place import Place
from models.state import State


app = Flask(__name__)
app.url_map.strict_slashes = False


@app.route('/hbnb')
def hbnb():
    '''The full hbnb page.'''
    all_states = list(storage.all(State).values())
    amenities = list(storage.all(Amenity).values())
    places = list(storage.all(Place).values())
    all_states.sort(key=lambda y: y.name)
    amenities.sort(key=lambda y: y.name)
    places.sort(key=lambda y: y.name)
    for state in all_states:
        state.cities.sort(key=lambda y: y.name)
    for place in places:
        place.description = Markup(place.description)
    vars = {
        'states': all_states,
        'amenities': amenities,
        'places': places
    }
    return render_template('100-hbnb.html', **vars)


@app.teardown_appcontext
def flask_teardown(exc):
    '''The Flask app/request context end event listener.'''
    storage.close()


if __name__ == '__main__':
    app.run(host='0.0.0.0', port='5000')
