#! /bin/bash

if [ -f .env ]; then
	export $(grep -v '^#' .env | xargs)
fi

PSQL="psql -h localhost -p 5432 -U postgres -d worldcup -X --no-align --tuples-only -c"

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]] 
  then
    #echo "$YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS"
    GET_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")

    if [[ -z $GET_WINNER_ID ]] 
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      GET_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    fi

    GET_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")

    if [[ -z $GET_OPPONENT_ID ]]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
      GET_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")
    fi

    GET_GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year = '$YEAR' AND round = '$ROUND' AND winner_id = '$GET_WINNER_ID';")

    if [[ -z $GET_GAME_ID ]] 
    then
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$GET_WINNER_ID', '$GET_OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS');")
    fi

  fi
done 
