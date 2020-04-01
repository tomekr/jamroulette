#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Setting up docker (this will take ~10 minutes on first run)"

echo "-> Building docker images"
docker-compose build

echo "-> web: Resetting database"
docker-compose run --rm web rails db:reset

echo "Setup completed."
