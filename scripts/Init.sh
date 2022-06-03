#! /bin/bash

integrationTestPath=./

source ${integrationTestPath}scripts/CommonLib.sh

# wait
sleep 3

# apply migration
applyMigration

# Loading db schema
loadPostgresSchema

# Loading mock stubs
initMockStubs "http://mock:80"