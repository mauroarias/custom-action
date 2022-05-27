#! /bin/bash

integrationTestPath=$1
migrationPath=$2

source ${integrationTestPath}share-qa-libs/scripts/CommonLib.sh

# Building docker test images
printTitleWithColor "building docker images" "${yellow}"
printMessage "Building docker init image"
dockerBuild ${integrationTestPath}share-qa-libs/DockerfileInit "itestinit:test" "--build-arg MIGRATION_PATH=$migrationPath --build-arg INTEGRATION_TEST_PATH=$integrationTestPath"
cd $integrationTestPath
printMessage "Building docker integration test image"
dockerBuild share-qa-libs/DockerfileItest "itest:test"

# Starting infra
docker-compose down
printTitleWithColor "Starting infra" "${yellow}"
docker-compose up -d || exitOnError "error starting infra"

# wait
sleep 5

# run tests
path=$(pwd)
mkdir ${path}/reporting
printTitleWithColor "Running Itests" "${yellow}"
getNetworkNameFromDockerCompose
docker run -i --network=$networkName -v ${path}/reporting:/reporting itest:test || printAlert "some tests fail, please check reporting"

# reporting logs
docker-compose logs -t > ${path}reporting/logs.log
 
# Stopping infra
printTitleWithColor "Stopping infra" "${yellow}"
docker-compose down || exitOnError "error stopping infra"
