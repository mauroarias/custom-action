#! /bin/bash

migrationPath=$1

if [ "$migrationPath" != "" ];
then
    dotnet tool install --global dotnet-ef
    dotnet ef migrations bundle --force
    mv efbundle dbMigration
fi