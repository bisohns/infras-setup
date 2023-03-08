#!/bin/bash
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export KOPS_STATE_STORE=s3://bisohns-k8s-local-state-store
#export NAME=bisons.k8s.local
export NAME=k8s.bisohns.com
export OIDC_STORE=s3://bisohns-k8s-local-oidc-store
export VPC_ID=vpc-de3b14b6
export MASTER_ZONES="eu-west-2a,eu-west-2b,eu-west-2c"
export MASTER_SIZE="t3.medium"
export NODE_SIZE="t3.medium"
