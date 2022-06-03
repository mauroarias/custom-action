# HOW TO

## CONFIGURATE TO USE

### docker-compose

### variables

### Database

### Mock server

xxx.

## ADD INTO A PROJECT

### copy & create files

- Copy docker-compose.template file to your local **Itest folder** and edit it.

### github actions workflow

## RUN LOCALLY

Probably some commands does not work on Windows OS.

### Prepare to run with Rider or Visual Studio IDE

#### 1. Load the shared qalib on your Itest project

On your local **Itest folder**, run the following command:
  docker run --rm --platform linux/amd64 -v $(pwd):/scripts mauroarias/share-qa-lib:latest /bin/cp -rf /share-qa-libs/ /scripts/

#### 2. Compile app service

On your local **Service root folder or on your dockerfile workpath**, run the following command:
  docker build -f <-Dockerfile's path->/Dockerfile --platform linux/amd64 --no-cache -t app:test .

#### 3. Compile your testing config project locally

On your local **service root folder**, run the following comand to build the initItest image:
  docker build -f <-integration test path->/share-qa-libs/DockerfileInit --build-arg MIGRATION_PATH=<-migration's project path, OPTIONAL if applies, ending in /-> --build-arg INTEGRATION_TEST_PATH=<-integration test path->/ --no-cache --platform linux -t itestinit:test .

ex:
Root_serviceProject:
    | ProjectSrc
    | IntegrationTest

On **Root_serviceProject** run:

docker build -f **IntegrationTest**/share-qa-libs/DockerfileInit --build-arg MIGRATION_PATH=**ProjectSrc/** --build-arg INTEGRATION_TEST_PATH=**IntegrationTest/** --no-cache --platform linux -t itestinit:test .

#### 4. Start your infra locally

On your local **Itest folder**:

- Make sure you have configured and set all environment vars configurate on your system.
- make:
    docker-compose up

#### 5. Run Itest from your IDE (Rider or Visual studio)

Go to you IDE and run your tests as ussually. **Please note that you probably must use the proper port and localhost as host**.

### Build &Run Itest from docker container

Please note that for now this option is available only on MacOS or Linux OS.
On your local **service root folder**:

- Compile your services, following:
  docker build -f <-Dockerfile's path->/Dockerfile --platform linux --no-cache -t app:test .
- Run Itest script comand:
  share-qa-libs/scripts/Itest.sh <-integration test path->/ <-migration's project path, OPTIONAL if applies, ending in /-> <-Test arguments if you have->
- Report will be available on **reporting** folder.
