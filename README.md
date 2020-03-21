# Jam Roulette
[![Build Status](https://travis-ci.com/tomekr/jamroulette.svg?branch=master)](https://travis-ci.com/tomekr/jamroulette)

Jam Roulette is a Rails (+ React, Typescript) application for layered jamming and collaboration.

## Development

### Docker

Build the image with `docker-compose build` (the first time building will take the longest)

To run the server, `docker-compose up` and point your browser to [http://localhost:3000/](http://localhost:3000/)

To just run the test suite, `docker-compose run web rake`

### Running locally

1. Run `bundle install`.
2. Run `bundle exec rails server`
3. Point your browser to [http://localhost:3000/](http://localhost:3000/)

