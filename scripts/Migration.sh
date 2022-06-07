#! /bin/bash

migrationList=$1
integrationTestPath=$2

if [ "$migrationList" != "" ];
then
  dotnet tool install --global dotnet-ef
  
  migrations=$(echo "$migrationList" | tr "|" "\n")
  for migration in $migrations
  do
    IFS='!' 
    read -ra item <<< "$migration"
    envsubst < "${integrationTestPath}"scripts/MigrationConfig__"${item[2]}"__usersettings.json > "${item[1]}"/usersettings.json
    dotnet ef migrations script -p "${item[1]}"*.csproj --output ./Schema.sql 
  done
fi