#! /bin/bash

migrationPath=$1
integrationTestPath=$2

if [ "$migrationPath" != "" ];
then
  source ${integrationTestPath}share-qa-libs/scripts/CommonLib.sh
    
  dotnet tool install --global dotnet-ef
  prepareConfigFile "migrationConfig__" $migrationPath
  cd $migrationPath
  dotnet publish --configuration Release 
  dotnet ef migrations bundle --force --configuration Release --self-contained 
  cd -
  mv ${migrationPath}efbundle dbMigration
fi