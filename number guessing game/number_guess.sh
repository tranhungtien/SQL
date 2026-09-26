#!/bin/bash

if [ -f .env ]; then
	export $(grep -v '^#' .env | xargs)
fi

PSQL="psql -h localhost -p 5432 -U postgres -d number_guess -X --no-align --tuples-only -c"


echo "Enter your username:"
read USER_NAME

if [[ -z $GET_USER_ID ]]
then
  	echo "Welcome, $USER_NAME! It looks like this is your first time here."
  	ADD_NEW_USER=$($PSQL "INSERT INTO users(user_name) VALUES('$USER_NAME');")
  	GET_USER_ID=$($PSQL "SELECT user_id FROM users WHERE user_name = '$USER_NAME';")
fi
