# Jam Roulette
[![Build Status](https://travis-ci.com/tomekr/jamroulette.svg?branch=master)](https://travis-ci.com/tomekr/jamroulette)

Jam Roulette is a Rails (+ React, Typescript) application for layered jamming and collaboration.

## Development

### Docker

#### Building and initializing the containers
This is required if  you've never built jamroulette via Docker before. This may also work to reset things in case Docker gets into a funky state.

1. Build the image with `docker-compose build` (the first time building will take the longest)
2. Run `docker-compose run web rails db:reset` to setup the database

#### Standing up a server

To run the server, `docker-compose up` and point your browser to [http://localhost:3000/](http://localhost:3000/)

#### Running the test suite

To just run the test suite, `docker-compose run web rake`

### Running locally

To run the rails server on your local machine (to make things like using byebug easier), follow these steps:

0. Start the db docker service `docker-compose up -d db`
1. Run `bundle install`.
2. Run `LOCAL=true bundle exec rails server` (`LOCAL=true` tells rails to use the database listening on localhost)
3. Point your browser to [http://localhost:3000/](http://localhost:3000/)


