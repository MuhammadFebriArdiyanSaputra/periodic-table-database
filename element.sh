
#! /bin/bash

PSQL() {
  psql --username=freecodecamp --dbname=periodic_table -t --no-align -F '|' -c "$1"
}

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

ELEMENT=$(PSQL "
SELECT
  e.atomic_number,
  e.name,
  e.symbol,
  t.type,
  p.atomic_mass,
  p.melting_point_celsius,
  p.boiling_point_celsius
FROM elements e
JOIN properties p USING(atomic_number)
JOIN types t USING(type_id)
WHERE e.atomic_number::TEXT = '$1'
   OR e.symbol = '$1'
   OR e.name = '$1';
")

# Check if element exists
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
else
  IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT <<< "$ELEMENT"

  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi
# Completed element lookup tests
# Finalize periodic table script
