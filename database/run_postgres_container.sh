#!/bin/bash
# Script to build and run PostgreSQL container using docker-compose
docker_compose_file="$(dirname "$0")/docker-compose.yml"

# If Dockerfile exists (old), rename to docker-compose.yml for compatibility
dockerfile_path="$(dirname "$0")/Dockerfile"
if [ -f "$dockerfile_path" ]; then
    mv "$dockerfile_path" "$(dirname "$0")/docker-compose.yml"
fi

# Build and run the container
echo "Starting PostgreSQL container with docker-compose..."
docker-compose -f "$docker_compose_file" up -d

if [ $? -eq 0 ]; then
    echo "PostgreSQL container is up and running."
    echo "Access: localhost:5434 (user: postgres, password: mysecretpassword, db: intelliquiz)"
else
    echo "Failed to start PostgreSQL container." >&2
    exit 1
fi
