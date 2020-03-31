# Jam Roulette
[![Build Status](https://travis-ci.com/tomekr/jamroulette.svg?branch=master)](https://travis-ci.com/tomekr/jamroulette)

Jam Roulette is a Rails (+ React, Typescript) application for layered jamming and collaboration.

## Contributing

We very much welcome PRs! Please fork this repo and see the project's [Trello board](https://trello.com/b/ftn4JCO8/jam-roulette-kanban) for open cards to take on. If available, cards labeled "good first issue" would be a good place to start. Alternatively, take a look at the [Bugs project](https://github.com/tomekr/jamroulette/projects/1) section on Github.

When you're done with working, please run `bundle exec rake` against the codebase. If everything passes, you can move on to opening the PR.

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

### Logging in

`db/seeds.rb` will create two users. You can Sign In with user `bob@example.com`, password `password`.

## Deployment

### Staging

The Heroku pipeline is currently configured to automatically deploy when changes are pushed to master. If you would like to deploy from the Heroku CLI, follow the instructions below.

This section requires that you:

1. Have the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#download-and-install) installed.
2. Have your CLI [connected to](https://devcenter.heroku.com/articles/heroku-cli#getting-started) your Heroku account. 
2. Have access to Jam Roulettes's Heroku environment.

To add a remote for staging:

1. Run `heroku git:remote -a jamroulette-staging`
2. Rename the remote with `git remote rename heroku staging`

To deploy the master branch run `git push staging master`

To deploy from a branch besides master `git push staging master`
