# HOW TO

## CONFIGURATE TO USE

### variables

### Database

### Mock server

xxx.

## ADD INTO A PROJECT

### github actions workflow

## RUN LOCALLY

### Load the share qa lib on your Itest project

On your local **Itest folder**, run the following comand:
  docker run --rm -v $(pwd):/scripts mauroarias/share-qa-lib:latest /bin/cp -rf /share-qa-libs/ /scripts/

### Compile your configure project locally

On your local **Itest folder**:

- Load the share qa libs. Please refer to: **Load the share qa lib on your Itest project** section
- Run the following comand to build the initItest image:
  docker build -f share-qa-libs/DockerfileInit -t itestinit:test . --no-cache

### Start your infra locally

On your local **Itest folder**:

- Compile your configure project. Please refer to: **Compile your configure project locally** section.
- Build your service using the proper name and tag. The same used in the docker-compose file.
- Make sure you have configured your system properlly. **Please refer to configurate section for more information**.
- Make sure you have set all environment vars configurate on your system. **Please check the docker-compose file & Configuration.sh file**.
- make:
    docker-compose up

### Run Itest from your IDE (Rider or Visual studio)

- Start the infra. Please refer to: **Start your infra locally** section.
- go to you IDE and run your tests as ussually. **Please note that you probably must use the proper port and localhost as host**.

### Run Itest from docker container

Please note that for now this option is available only on MacOS or Linux OS.
On your local **Itest folder**:

- Run the following comand:
  share-qa-libs/scripts/Itest.sh
- Report will be available on **reporting** folder.
