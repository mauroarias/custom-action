#! /bin/bash

source scripts/CommonLib.sh

# wait
sleep 2

# Loading db schema
loadPostgresSchema

# Loading mock stubs
initMockStubs "http://mock:80"