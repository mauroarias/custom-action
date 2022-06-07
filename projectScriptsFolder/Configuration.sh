#! /bin/bash

#----------------------------------------------------------------------
# AREA 51 :P, FRAMEWORK vars area PLEASE BE careful.
#----------------------------------------------------------------------

#----------------------------------------------------------------------
# Developer Area, please put here your vars.
#----------------------------------------------------------------------
export POSTGRES_DB=db
export POSTGRES_USER=user
export POSTGRES_PASSWORD=password 

ITEST_PATH=Projects/ProjectServer.Test

# each line:
# - external git repository, if it's a mono repo please set empty string.
# - migration path
# - migration DB
# - migration user
# - migration password
# ex:
migration=("!Projects/ProjectServer/!$POSTGRES_DB!$POSTGRES_USER!$POSTGRES_PASSWORD")