#!/bin/bash
# Calculates how many hours and days user spent on steam
# Requires curl

#Functions
print_help() {
	echo ${0}: missing API_KEY and STEAM_ID arguments
	echo
	echo Usage: 	
	echo -e '\t''./spentHours.sh <api_key> <steam_id>'
	echo Example:
	echo -e '\t'./spentHours.sh 1591242F6FDDE8EE5BEACDA87677AAF7 28561626259360116
}

# Execution
if [ $# -ne 2 ]; then
	print_help
	exit 1;
fi

API_KEY=$1
STEAM_ID=$2
TMP_FILE=$TEMP/spentHours
STEAM_API='https://api.steampowered.com'
GAMES_PATH='/IPlayerService/GetOwnedGames/v0001/'
PARAMS='?include_played_free_games&format=json'
REQUEST="$STEAM_API$GAMES_PATH$PARAMS&key=$API_KEY&steamid=$STEAM_ID"

curl -s $REQUEST > $TMP_FILE

grep -Eo '"playtime_forever":[0-9]+' $TMP_FILE | cut -d ':' -f 2 | awk '{sum+=$1} END {	
	print "\tHours wasted:\t\t\t" sum/60
	print "\tDays wasted:\t\t\t" sum/1440
}
'

rm $TMP_FILE

