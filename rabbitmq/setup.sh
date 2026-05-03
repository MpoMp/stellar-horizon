#!/bin/bash

echo "RabbitMQ setup initiating."

CONTAINER_NAME="stellar-rmq"
ADMIN_USER="mikalaras"
PASSWORD_FILE="adminpw.txt"

if [[ ! -s "$PASSWORD_FILE" ]]; then
  echo "Error: Password file $PASSWORD_FILE is missing or empty."
  exit 1
fi

PWD="$(< "$PASSWORD_FILE")"

# Check if container is running
if ! docker ps --format '{{.Names}}' | grep -q "$CONTAINER_NAME"; then
  echo "Error: Container $CONTAINER_NAME is not running."
  exit 1
fi

echo "Connecting to RabbitMQ container: $CONTAINER_NAME"

RMQ_USERS="$(docker exec "$CONTAINER_NAME" rabbitmqctl list_users)"

# Check if user exists
if echo "$RMQ_USERS" | grep -q "$ADMIN_USER"; then
  echo "User $ADMIN_USER already exists. Skipping user creation."
else
  echo "Setting up new RMQ admin user: $ADMIN_USER"

  # Create user
  docker exec "$CONTAINER_NAME" rabbitmqctl add_user "$ADMIN_USER" "$PWD"

  # Set user tags (administrator)
  docker exec "$CONTAINER_NAME" rabbitmqctl set_user_tags "$ADMIN_USER" administrator

  # Set permissions (full access to default vhost "/")
  docker exec "$CONTAINER_NAME" rabbitmqctl set_permissions -p / "$ADMIN_USER" ".*" ".*" ".*"

  echo "User $ADMIN_USER has been set up successfully."
fi


# Delete the default guest user
if echo "$RMQ_USERS" | grep -q "guest"; then
  echo "Deleting default guest user..."
  docker exec "$CONTAINER_NAME" rabbitmqctl delete_user guest
  echo "Guest user has been deleted."
fi

echo "RabbitMQ setup has finished successfully."
