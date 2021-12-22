#!/bin/bash
# Set app-specific defaults here.  If 'true', these tasks will be run every time the container starts, unless overridden at runtime
RAKE_ASSETS_PRECOMPILE=${RAKE_ASSETS_PRECOMPILE:-true}
RAKE_DB_CREATE=${RAKE_DB_CREATE:-false}
RAKE_DB_SETUP=${RAKE_DB_SETUP:-false}
RAKE_DB_CLEAR=${RAKE_DB_CLEAR:-false}
RAKE_DB_MIGRATE=${RAKE_DB_MIGRATE:-true}
RAKE_DB_SEED=${RAKE_DB_SEED:-false}
# Seeding feature flags
## Continue on if seeding fails
RAKE_DB_SEED_FAIL_FORWARD=${RAKE_DB_SEED_FAIL_FORWARD:-true}
## Retry until seeding succeeds
RAKE_DB_SEED_RETRY=${RAKE_DB_SEED_RETRY:-false}

function bundle-exec-rake {
  echo "............................................"
  echo "Starting ${1}..."
  echo "............................................"
  EXECUTION_OUTPUT=$(RAILS_ENV=${2} bundle exec rake ${1} 2>&1)
  EXECUTION_RESPONSE=$?
  if [ "$EXECUTION_RESPONSE" != "0" ]; then
    echo $EXECUTION_OUTPUT | grep -q "another migration process is currently running" > /dev/null
    MIGRATION_RUNNING=$(echo $EXECUTION_OUTPUT | grep -q "another migration process is currently running" > /dev/null; echo $?)
    CREATE_RUNNING=$(echo $EXECUTION_OUTPUT | grep -q "duplicate key value violates unique constraint" > /dev/null; echo $?)
    while [ "$MIGRATION_RUNNING" == "0" ] || [ "$CREATE_RUNNING" == "0" ] ; do
      SLEEP_TIME=$(( ( RANDOM % 10 )  + 1 ))
      echo "WARN: ${1} likely already running.  Sleeping for ${SLEEP_TIME} before retrying"
      sleep ${SLEEP_TIME}
      EXECUTION_OUTPUT=$(RAILS_ENV=${2} bundle exec rake ${1} 2>&1)
      EXECUTION_RESPONSE=$?
      MIGRATION_RUNNING=$(echo $EXECUTION_OUTPUT | grep -q "another migration process is currently running" > /dev/null; echo $?)
      CREATE_RUNNING=$(echo $EXECUTION_OUTPUT | grep -q "duplicate key value violates unique constraint" > /dev/null; echo $?)
      [ "$CREATE_RUNNING" == "0" ] && [ "${1}" == "db:seed" ] && [ "$RAKE_DB_SEED_RETRY" == "false" ] && CREATE_RUNNING=1 && EXECUTION_RESPONSE=0
    done
    if [ "$EXECUTION_RESPONSE" != "0" ]; then
      if [ "${1}" == "db:seed" ] && [ "${RAKE_DB_SEED_FAIL_FORWARD}" == "true" ]; then
        echo "WARNING: ${1} failed, but RAKE_DB_SEED_FAIL_FORWARD is set to true, so continuing on"
        echo "Done ${1}"
      else
        echo "${EXECUTION_OUTPUT}"
        echo "FATAL: ${1} failed.  Container will now stop."
        exit 10
      fi
    else
      echo "Done ${1}"
    fi
  else
    echo "Done ${1}"
  fi
}

# Run any required rake tasks here.  Disable by using a feature flag at the top of this file
if [ "$RAKE_ASSETS_PRECOMPILE" == "true" ]; then bundle-exec-rake assets:precompile $RAILS_ENV; fi
if [ "$RAKE_DB_CREATE" == "true" ];         then bundle-exec-rake db:create $RAILS_ENV; fi
#if [ "$RAKE_DB_SETUP" == "true" ];          then bundle-exec-rake db:setup $RAILS_ENV; fi
if [ "$RAKE_DB_CLEAR" == "true" ];          then bundle-exec-rake db:clear $RAILS_ENV; fi
if [ "$RAKE_DB_MIGRATE" == "true" ];        then bundle-exec-rake db:migrate $RAILS_ADMIN_ENV; fi
if [ "$RAKE_DB_SEED" == "true" ];           then bundle-exec-rake db:seed $RAILS_ENV; fi

#nc -z $RDS_URL 5432

echo "RAILS_ENV ==$RAILS_ENV" 
if [ "$RAILS_ENV" == "docker" ]; then
 echo "Starting webbrick..."
 bundle exec rails server -b 0.0.0.0
else
  echo "Starting unicorn, output to /proc/1/fd/1-2 ..."
  bundle exec unicorn -c config/unicorn/config.rb -E $RAILS_ENV > /proc/1/fd/1 2>/proc/1/fd/2
fi

if [[ $? -eq 0 ]]; then
  echo "Rails server exited without error code, but it probably shouldn't have. Container will now stop."
else
  echo "FATAL: Rails server exited with error code $?.  Container will now stop."
  exit 20
fi
