#!/bin/bash

# Generate random values
APP_ID=$(openssl rand -hex 16)
APP_KEY="base64:$(openssl rand -base64 32)"
DB_PASSWORD=$(openssl rand -base64 32)
REDIS_PASSWORD=$(openssl rand -base64 32)
PUSHER_APP_ID=$(openssl rand -hex 32)
PUSHER_APP_KEY=$(openssl rand -hex 32)
PUSHER_APP_SECRET=$(openssl rand -hex 32)

# Write everything to .env (overwrite existing file)
cat <<EOF > .env
APP_ID=$APP_ID
APP_KEY=$APP_KEY
DB_PASSWORD=$DB_PASSWORD
REDIS_PASSWORD=$REDIS_PASSWORD
PUSHER_APP_ID=$PUSHER_APP_ID
PUSHER_APP_KEY=$PUSHER_APP_KEY
PUSHER_APP_SECRET=$PUSHER_APP_SECRET
EOF

echo ".env file updated with new secrets."

