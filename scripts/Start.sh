#! /bin/bash

file="${BASH_SOURCE[0]:-$0}";
dir="$( cd -P "$( dirname -- "$file"; )" &> /dev/null && pwd 2> /dev/null; )";
integrationTestPath=`dirname -- "$0"`
integrationTestPath=$(dirname $(dirname $integrationTestPath))/

source "$dir/CommonLib.sh"

# parsing docker Architecture if it's present
parsingDockerArch

# build app if it's requested
buildApp

# migrations
getMigrationList

# build start and wait infra
buildStartWaitInfra