#!/usr/bin/python3
"""This module contains state class"""
from models.base_model import BaseModel, Base
from sqlalchemy.orm import relationship, backref
from sqlalchemy import Column, String
from os import getenv


class State(BaseModel, Base):
    """This is the class for State
    Attributes:
        name: input name
        __tablename__: name of the table
        cities: relationship with City
    """
    __tablename__ = "states"
    name = Column(String(128), nullable=False)
    cities = relationship(
        "City",
        cascade="all,delete,delete-orphan",
        backref=backref("state", cascade="all,delete"),
        passive_deletes=True,
        single_parent=True)

    if getenv("HBNB_TYPE_STORAGE") != "db":
        @property
        def cities(self):
            """returns list of City instances with state_id"""
            from models import storage
            from models import City
            return [val for it, val in storage.all(City).items()
                    if val.state_id == self.id]
