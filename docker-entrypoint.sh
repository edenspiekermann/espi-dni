#!/bin/sh

#set -e

mix local.hex --force
mix deps.get
mix ecto.create && mix ecto.migrate
npm install

exec "$@"
