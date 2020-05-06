# Jam Roulette
[![Build Status](https://travis-ci.com/tomekr/jamroulette.svg?branch=master)](https://travis-ci.com/tomekr/jamroulette) [![Maintainability](https://api.codeclimate.com/v1/badges/977570230ae4fde335ab/maintainability)](https://codeclimate.com/github/tomekr/jamroulette/maintainability)

Jam Roulette is a Rails (+ React, Typescript) application for layered jamming and collaboration.

<img src="https://user-images.githubusercontent.com/723637/81198847-8dc3d580-8f87-11ea-97b6-08e0a0bc5f91.png" alt="alt text" width="400"><img src="https://user-images.githubusercontent.com/723637/81198851-8e5c6c00-8f87-11ea-8fdc-dbc3228e91c5.png" alt="alt text" width="400">

## Contributing

We very much welcome PRs! Please fork this repo and see the project's [Trello board](https://trello.com/b/ftn4JCO8/jam-roulette-kanban) for open cards to take on. If available, cards labeled "good first issue" would be a good place to start. Alternatively, take a look at the [Bugs project](https://github.com/tomekr/jamroulette/projects/1) section on Github.

When you're done with working, please run `bundle exec rake` against the codebase. If everything passes, you can move on to opening the PR.

## Development

### Docker

#### Building and initializing the containers

This is required if  you've never built jamroulette via Docker before. This may also work to reset things in case Docker gets into a funky state.

1. Run `script/setup-docker.sh` (this could take up to ~10 minutes to finish the first time)

#### Starting up the web server (in Docker)

1. Run `script/start-docker-server.sh`
2. Point your browser to [http://localhost:3000/](http://localhost:3000/)

### Running the web server locally

Ensure dependencies are installed locally:

1. Run `bundle install`

To run the rails server on your local machine (to make things like using byebug easier), follow these steps:

1. Run `script/start-local-server.sh`
2. Point your browser to [http://localhost:3000/](http://localhost:3000/)

#### Running the test suite

To just run the test suite, `docker-compose run web rake`

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

To deploy from a branch besides master `git push staging delayed-job:master -f`
