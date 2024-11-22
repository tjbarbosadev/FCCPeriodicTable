#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# check parameter

# returns if no argument is passed
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# check if atomic_number
if [[ $1 =~ ^-?[0-9]+$ ]]
then
  CONDITION="atomic_number=$1"
# check if symbol
elif [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]
then
  CONDITION="symbol='$1'"
# check if name
elif [[ $1 =~ ^[a-zA-Z]{3,}$ ]]
then
  CONDITION="name='$1'"
# return if none of above
else
  echo "I could not find that element in the database."
fi

# main query
QUERY=$($PSQL "SELECT * FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE $CONDITION LIMIT 1")

if [[ ! -z $QUERY ]]
then
  # show data
  echo "$QUERY" | while IFS="|" read ATOMIC_NUMBER TYPE_ID ATOMIC_MASS M_POINT B_POINT TYPE SYMBOL NAME
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $M_POINT celsius and a boiling point of $B_POINT celsius."
  done
else
  # exit if query returns empty
  echo "I could not find that element in the database."
fi
