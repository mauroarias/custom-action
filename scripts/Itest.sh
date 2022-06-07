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

# Building test docker image
printTitleWithColor "building test docker image" "${yellow}"
dockerBuild "${integrationTestPath}share-qa-libs/DockerfileItest" "itest:test" "--build-arg INTEGRATION_TEST_PATH=$integrationTestPath --build-arg TEST_ARG=$TEST_BUILD_ARG --no-cache --platform $dockerArch" || exitOnError "error generating docker test image"

# run tests
reportingPath="$(pwd)/${integrationTestPath}reporting"
printMessageWithColor "reporting in path $reportingPath" "${yellow}" 
mkdir "${reportingPath}"
printTitleWithColor "Running Itests" "${yellow}"
getNetworkNameFromDockerCompose
docker run -i --network="$networkName" --platform "$dockerArch" -v "${reportingPath}":/reporting itest:test #|| printAlert "some tests fail, please check reporting"

# reporting logs
docker-compose -f "${integrationTestPath}docker-compose.yml" logs -t > "${reportingPath}"/logs.log
 
# Stopping infra
printTitleWithColor "Stopping infra" "${yellow}"
docker-compose -f "${integrationTestPath}docker-compose.yml" down || exitOnError "error stopping infra"