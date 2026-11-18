#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# start with winner name and search teams table for name, get winner_id
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

if [[ $WINNER != winner ]] # eliminates header from data
then
  # if no name
  if [[ -z $WINNER_ID ]]
  then
    # add to team table
    INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

    # get team_id number for winner_id based on name
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi
fi

# get opponent name and search teams table for name
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
if [[ $OPPONENT != opponent ]] # eliminates header
then
  # if no name
  if [[ -z $OPPONENT_ID ]]
  then
  # add to teams table 
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

    # get team_id number for opponent_id based on name
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi
fi

# check games table for exiting record using year, round, winner_id, and opponent_id
if [[ $ROUND != round ]] # eliminates header
then
GAME_RECORD=$($PSQL "SELECT game_id FROM games WHERE year=$YEAR AND round='$ROUND' AND winner_id=$WINNER_ID AND opponent_id=$OPPONENT_ID")

  # if not found
  if [[ -z $GAME_RECORD ]]
  then
    # add to games table 
    #echo "This is the winner ID: $WINNER_ID and this is the opponent ID: $OPPONENT_ID"
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
fi

# this will be last line
done
