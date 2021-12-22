#!/bin/bash -e

export AWS_DEFAULT_REGION=us-east-1

## Functions
function local-usage () {
  echo "FATAL: Must set all environment variables before this container can be launched. Exiting.
"
}
function aws-usage () {
  echo "FATAL: Must set all environment variables before this container can be launched. Exiting.

  Usage: Container must be run with the following environment variables:
  AWS_ENVIRONMENT: Resource environment for this service.  Used to refernce ParameterStore values.  Ex: dev, demo, qa, stg, prod, trn
"
}
function getallparametersbyprefix () {
  PARAMETER_STORE_PREFIX=$1
  echo "Getting parameters from PARAMETER_STORE_PREFIX=${PARAMETER_STORE_PREFIX}"
  echo "Testing pulling data from ParameterStore..."
  aws ssm get-parameters-by-path --path "${PARAMETER_STORE_PREFIX}" > /dev/null && echo "Success ${PARAMETER_STORE_PREFIX}" || ( echo "FATAL: Could not get-parameters-by-path from ParameterStore with value '${PARAMETER_STORE_PREFIX}/*'"; exit 10; )
  source <(aws ssm get-parameters-by-path --path "${PARAMETER_STORE_PREFIX}" --with-decryption | jq -r '.Parameters[] | "export "+(.Name | split("/") | reverse |.[0])+"=\""+.Value+"\""' )
  echo "Successfully set the following environment variables:"
  aws ssm get-parameters-by-path --path "${PARAMETER_STORE_PREFIX}" | jq -r '.Parameters[] | .Name | split("/") | reverse |.[0]'
}
function get_dotenv_s3 () {
  echo "Beginning sync of s3://${DOTENV_S3_PATH}..."
  aws s3 cp "s3://${DOTENV_S3_PATH}" . --recursive || ( echo "FATAL: Could not sync files from S3"; exit 30; )
  echo "Completed S3 File sync."
}


# Check if running in AWS
if aws sts get-caller-identity > /dev/null 2>&1; then
  if [ -z "${AWS_ENVIRONMENT}" ]; then
    aws-usage
    exit 35
  else
    # We're using aws, pull some env vars from parameter store
    echo "Entrypoint: running in AWS"
    ## Get all Parameters from path in Parameter Store
    #getallparametersbyprefix "/${AWS_ENVIRONMENT}-certify/"

    ## Get Single Parameter and inject into envvar

    ## Pull other configuration files from s3
    #get_dotenv_s3
  fi
else
  echo "Entrypoint: NOT running in AWS"
#    local-usage
#    exit 40
fi

exec "$@"
