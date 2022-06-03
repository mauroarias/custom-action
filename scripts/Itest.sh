#! /bin/bash

integrationTestPath=$1
migrationPath=$2
testArg=$3

source ${integrationTestPath}share-qa-libs/scripts/CommonLib.sh

# Building docker test images
printTitleWithColor "building docker images" "${yellow}"
printMessage "Building docker init image"
dockerBuild ${integrationTestPath}share-qa-libs/DockerfileInit "itestinit:test" "--build-arg MIGRATION_PATH=$migrationPath --build-arg INTEGRATION_TEST_PATH=$integrationTestPath --no-cache --platform linux/amd64" || exitOnError "error generating docker init image"
printMessage "Building docker integration test image"
dockerBuild ${integrationTestPath}share-qa-libs/DockerfileItest "itest:test" "--build-arg INTEGRATION_TEST_PATH=$integrationTestPath --build-arg TEST_ARG=$testArg --no-cache --platform linux/amd64" || exitOnError "error generating docker test image"

# Starting infra
docker-compose down
printTitleWithColor "Starting infra" "${yellow}"
cd ${integrationTestPath}
docker-compose up -d || exitOnError "error starting infra"

# wait
sleep 10

# run tests
path=$(pwd)
mkdir ${path}/reporting
printTitleWithColor "Running Itests" "${yellow}"
getNetworkNameFromDockerCompose
pwd
echo "docker run -i --network=$networkName --platform linux/amd64 -v ${path}/reporting:/reporting itest:test"
docker run -i --network=$networkName --platform linux/amd64 -v ${path}/reporting:/reporting itest:test #|| printAlert "some tests fail, please check reporting"

# reporting logs
docker-compose logs -t > ${path}/reporting/logs.log
 
# Stopping infra
printTitleWithColor "Stopping infra" "${yellow}"
docker-compose down || exitOnError "error stopping infra"
