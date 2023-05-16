-- creates necessary tables for airbnb project in database
USE hbnb_dev_db;
CREATE TABLE IF NOT EXISTS amenities (
    id VARCHAR(60) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    name VARCHAR(128) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS states (
    id VARCHAR(60) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    name VARCHAR(128) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS cities (
    id VARCHAR(60) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    name VARCHAR(128) NOT NULL,
    state_id VARCHAR(60) NOT NULL,
    FOREIGN KEY (state_id) REFERENCES states(id) ON DELETE CASCADE,
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(60) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    email VARCHAR(128) NOT NULL,
    password VARCHAR(128) NOT NULL,
    first_name VARCHAR(128),
    last_name VARCHAR(128),
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS places (
    id VARCHAR(60) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    city_id VARCHAR(60) NOT NULL,
    user_id VARCHAR(60) NOT NULL,
    name VARCHAR(128) NOT NULL,
    description VARCHAR(1024),
    number_rooms INTEGER NOT NULL DEFAULT 0,
    number_bathrooms INTEGER NOT NULL DEFAULT 0,
    max_guest INTEGER NOT NULL DEFAULT 0,
    price_by_night INTEGER NOT NULL DEFAULT 0,
    latitude FLOAT,
    longitude FLOAT,
    FOREIGN KEY (city_id) REFERENCES cities(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS place_amenity (
    place_id VARCHAR(60) NOT NULL,
    amenity_id VARCHAR(60) NOT NULL,
    FOREIGN KEY (place_id) REFERENCES places(id),
    FOREIGN KEY (amenity_id) REFERENCES amenities(id),
    PRIMARY KEY (place_id, amenity_id)
);
CREATE TABLE IF NOT EXISTS reviews (
    id VARCHAR(60) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    text VARCHAR(1024) NOT NULL,
    place_id VARCHAR(60) NOT NULL,
    user_id VARCHAR(60) NOT NULL,
    FOREIGN KEY (place_id) REFERENCES places(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (id)
);

use hbnb_test_db;

CREATE TABLE IF NOT EXISTS amenities (
    id VARCHAR(60) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    name VARCHAR(128) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS states (
    id VARCHAR(60) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    name VARCHAR(128) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS cities (
    id VARCHAR(60) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    name VARCHAR(128) NOT NULL,
    state_id VARCHAR(60) NOT NULL,
    FOREIGN KEY (state_id) REFERENCES states(id) ON DELETE CASCADE,
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(60) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    email VARCHAR(128) NOT NULL,
    password VARCHAR(128) NOT NULL,
    first_name VARCHAR(128),
    last_name VARCHAR(128),
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS places (
    id VARCHAR(60) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    city_id VARCHAR(60) NOT NULL,
    user_id VARCHAR(60) NOT NULL,
    name VARCHAR(128) NOT NULL,
    description VARCHAR(1024),
    number_rooms INTEGER NOT NULL DEFAULT 0,
    number_bathrooms INTEGER NOT NULL DEFAULT 0,
    max_guest INTEGER NOT NULL DEFAULT 0,
    price_by_night INTEGER NOT NULL DEFAULT 0,
    latitude FLOAT,
    longitude FLOAT,
    FOREIGN KEY (city_id) REFERENCES cities(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS place_amenity (
    place_id VARCHAR(60) NOT NULL,
    amenity_id VARCHAR(60) NOT NULL,
    FOREIGN KEY (place_id) REFERENCES places(id),
    FOREIGN KEY (amenity_id) REFERENCES amenities(id),
    PRIMARY KEY (place_id, amenity_id)
);
CREATE TABLE IF NOT EXISTS reviews (
    id VARCHAR(60) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    text VARCHAR(1024) NOT NULL,
    place_id VARCHAR(60) NOT NULL,
    user_id VARCHAR(60) NOT NULL,
    FOREIGN KEY (place_id) REFERENCES places(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (id)
);
