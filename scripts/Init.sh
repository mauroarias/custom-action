#! /bin/bash

integrationTestPath=./

source scripts/CommonLib.sh

# wait
sleep 2

# apply migration
applyMigration "$CONNECTION"

# Loading db schema
loadPostgresSchema

# Loading mock stubs
initMockStubs "http://mock:80"