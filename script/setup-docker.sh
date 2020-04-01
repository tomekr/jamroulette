#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Setting up docker (this will take ~5 minutes on first run)"
echo "-> Webpack will compile assets"

echo "-> Building docker images"
docker-compose build
echo "-> web: Resetting database"
docker-compose run --rm web rails db:reset
echo "-> webpacker: Precompiling assets"
docker-compose run --rm wepacker bundle exec rails assets:precompile

echo "Setup completed."
