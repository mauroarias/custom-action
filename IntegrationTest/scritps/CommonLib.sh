#! /bin/bash

export TERM=xterm

# color definition
red=`tput setaf 1`
green=`tput setaf 2`
orange=`tput setaf 3`
blue=`tput setaf 4`
violet=`tput setaf 5`
agua=`tput setaf 6`
white=`tput setaf 7`
gris=`tput setaf 8`
reset=`tput sgr0`

source scripts/Configuration.sh

#-------------------------------------------
# Common vars
#-------------------------------------------

#-------------------------------------------
# Common functions
#-------------------------------------------

#printAlert <message to print> 
printAlert () {
  message=$1
	printTitleWithColor "$message" "${red}"
}

#printAlert <message to print> <color> 
printTitleWithColor () {
  message=$1
  color=$2
	echo "$color*******************************"
	echo "$message"
	echo "*******************************${reset}"
}

#printMessage <message to print> 
printMessage () {
  message=$1
	echo "${agua}$message${reset}"
}

#printMessageWithColor <message to print> <color> 
printMessageWithColor () {
  message=$1
  color=$2
	echo "$color$message${reset}"
}

error () {
	exit 1
}

exitOnError () {
  message=$1
	printAlert "$message"
	error
}

traceOff () {
	set +e
}

traceOn () {
	set -e
}

waitServerUp () {
  serverUri=$1
  serverName=$2
  waitSec=$3
	counter=0
	while ! curl --silent --fail -H 'Content-Type: application/json' -X GET "$serverUri"; do
		sleep 1;
		counter=$((counter+1))
		echo "waiting for $serverName up, counter $counter"
		if [ $counter -gt $waitSec ]
		then
			exitOnError "Error starting $serverName server"
		fi
	done
}

getNetworkNameFromDockerCompose () {
  networkName=$(docker inspect $(docker-compose ps -q | head -n 1) | jq -r '.[0].NetworkSettings.Networks | keys | .[]')
}

dockerBuild () {
  file=$1
  tag=$2
  docker build -f $file -t $tag .
}

initMockStubs () {
  mockUri=$1
  if [ -f "scripts/Wiremock.json" ];
  then
    # preparing stubs
    printTitleWithColor "cleaning all stubs" "${yellow}"
    curl --silent --fail -X DELETE "$mockUri/__admin/mappings" || exitOnError "error resetting stubs"
    for stub64 in $(jq -c -r '.stubs[] | @base64' 'scripts/Wiremock.json');
    do
      stub=$(echo "$stub64" | base64 --decode)
      printMessage "posting request $stub"
      curl --silent --fail -X POST "$mockUri/__admin/mappings" -H 'Content-Type: application/json' -d "$stub" || exitOnError "error posting stub"
    done
  fi
}

loadPostgresSchema () {
  if [ -f "scripts/Wiremock.json" ];
  then
    # loading db schema
    printTitleWithColor "loading db schema" "${yellow}"
    export PGPASSWORD=$POSTGRES_PASSWORD
    psql -h postgres -U $POSTGRES_USER -d $POSTGRES_DB -f scripts/Schema.sql || exitOnError "error loading schema"
  fi
}