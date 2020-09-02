#!/usr/bin/env sh
ATTEMPTS_MAX_COUNT=40
TIMEOUT=10
EXPECTED_STREAMS='["logs","metrics","traces"]'

ATTEMPT=1
while [ "$ATTEMPT" -le "$ATTEMPTS_MAX_COUNT" ]; do
  if [ "$(curl 'http://localhost:6307/rules/list' -H 'masterApiKey: 123' | jq length)" = "9" ]; then
      echo success;
      break;
  fi;
  echo "$ATTEMPT attempt failed."

  if [ "$ATTEMPT" -eq "$ATTEMPTS_MAX_COUNT" ]; then
      echo "Can't ping gate!"
      exit 1;
  fi;

  ATTEMPT=$(($ATTEMPT+1))
  sleep $TIMEOUT;
done
