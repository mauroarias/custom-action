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

if [ -f "${integrationTestPath}scripts/Configuration.sh" ];
then
  source ${integrationTestPath}scripts/Configuration.sh
fi

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

debugOn () {
  set -x
}

debugOff () {
  set +x
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
  arg=$3
  docker build $arg -f $file -t $tag .
}

initMockStubs () {
  mockUri=$1
  if [ -f "${integrationTestPath}scripts/Wiremock.json" ];
  then
    # watting for mock up
    waitServerUp "$mockUri/__admin/mappings" "mock" "30"
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

prepareConfigFile () {
  filePrefix=$1
  destPath=$2
  ls ${integrationTestPath}scripts/$filePrefix*.json | while read a; do n=$(echo $a | sed -e "s!^${integrationTestPath}scripts/$filePrefix!!"); envsubst < $a > $destPath$n; done
}

applyMigration () {
  if [ -f "${integrationTestPath}migration/dbMigration" ];
  then 
    prepareConfigFile "migrationConfig__" "./"
    # loading db migration
    printTitleWithColor "loading db migration" "${yellow}"
    ${integrationTestPath}migration/dbMigration
  fi
}

loadPostgresSchema () {
  if [ -f "${integrationTestPath}scripts/Schema.sql" ];
  then
    # loading db schema
    printTitleWithColor "loading db schema" "${yellow}"
    export PGPASSWORD=$POSTGRES_PASSWORD
    psql -h postgres -U $POSTGRES_USER -d $POSTGRES_DB -f ${integrationTestPath}scripts/Schema.sql || exitOnError "error loading schema"
  fi
}