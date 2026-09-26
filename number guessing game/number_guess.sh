#!/bin/bash

if [ -f .env ]; then
	export $(grep -v '^#' .env | xargs)
fi

PSQL="psql -h localhost -p 5432 -U postgres -d number_guess -X --no-align --tuples-only -c"


echo "Enter your username:"
read USER_NAME
