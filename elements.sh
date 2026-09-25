#!/bin/bash

if [ -f .env ]; then
	export $(grep -v '^#' .env | xargs)
fi

PSQL="psql -h localhost -p 5432 -U postgres -d bikes -X --tuples-only -c"
