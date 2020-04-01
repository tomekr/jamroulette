#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting Jam Roulette..."
echo "-> Starting docker web server"
docker-compose up
