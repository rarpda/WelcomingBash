#!/bin/bash

#Get current location
get_current_temperature(){
	LOCATION=$1
	QUERY="https://locator-service.api.bbci.co.uk/locations?api_key=AGbFAKx58hyjQScCXIYrxuEwJh2W2cmv&stack=aws&locale=en&filter=international&place-types=settlement&order=importance&s=${LOCATION}&a=true&format=json"
	LAST_REPORT=$(curl -s -m 2 -X GET -H "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36" $QUERY | jq '.response.results.results | last')
	id=$(echo $LAST_REPORT | jq -r '.id')
	NEW_LOCATION=$(echo $LAST_REPORT | jq -r '.name')
	bbcweatherTemp=$(curl -s -m 2 -X GET -H "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36" "https://weather-broker-cdn.api.bbci.co.uk/en/forecast/aggregated/${id}" | jq '.forecasts | last | .summary.report.maxTempC')
	printf "The max temperature in $NEW_LOCATION is $bbcweatherTemp degrees Celsius\n"
}

check_ip_change() {
	CURRENT_IP=$1
	FILENAME="ip_address.txt"
	IP_SAVED=$(cat $FILENAME | xargs)
	if [[ $CURRENT_IP != $IP_SAVED ]]
	then 
	echo "$CURRENT_IP" > $FILENAME
	printf "IP changed from $IP_SAVED to $CURRENT_IP \n" 
	# Send notification
	python3 main.py "IP changed from $IP_SAVED to $CURRENT_IP"
	else
	printf "Public IP Address: $CURRENT_IP \n"
	fi
}

time=$(date '+%k')
if [[ $time -ge 17 ]] || [[ $time -le 6 ]]
	then
	GREETING="Good Evening"
elif [[ $time -le  12 ]]
	then
	GREETING="Good Morning"
else
	GREETING="Good Afternoon"
fi


printf "$GREETING, $(whoami)! You have reached through to $(hostname).\nThese are my addresses: \n"
printf "Private IP Address:"
IP_ADDRESS=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
for n in $IP_ADDRESS;
do
	printf " $n "
done
printf "\n"
printf "It's $(date '+%A') and the date is $(date '+%D').\n"

PUBLIC_IP=$(curl -s -m 2 -X GET https://api.ipify.org)
check_ip_change $PUBLIC_IP

if [ $# -eq 0 ]
then
	get_current_temperature "LONDON"
else
	get_current_temperature $1
fi

exec bash

exit
