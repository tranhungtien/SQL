#!/bin/bash

if [ -f .env ]; then
	export $(grep -v '^#' .env | xargs)
fi

PSQL="psql -h localhost -p 5432 -U postgres -d bikes -X --tuples-only -c"

if [[ ! $1 ]] 
then
	echo "Please provide an element as an argument."
else 
	if [[ $1 =~ ^[0-9]+$ ]]
	then 
		CONDITION="atomic_number = $1"
	else 
		CONDITION="symbol = '$1' OR name = '$1'"
	fi
fi
