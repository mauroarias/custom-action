#! /bin/bash

migrationPath=$1
integrationTestPath=$2

if [ "$migrationPath" != "" ];
then
  dotnet tool install --global dotnet-ef
  envsubst < ${integrationTestPath}scripts/Config__usersettings.json > $migrationPath/usersettings.json
  dotnet ef migrations script -p ${migrationPath}*.csproj --output ./Schema.sql 
fi