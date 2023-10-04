#!/usr/bin/env bash
set -x

myState="/tmp/${TF_VAR_envBuild}"


# Copy the remote file over to the local workstation
aws s3 cp "s3://${TF_VAR_stateBucket}/${myComponent}/${TF_VAR_envBuild}" "$myState"

# open the file
code "$myState"
