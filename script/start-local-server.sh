#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting Jam Roulette..."
echo "-> Starting postgres and webpacker in detached mode (containers run in the background) "
docker-compose up -d db webpacker

echo "-> Starting local web server"
LOCAL=true bundle exec rails server
