#!/usr/bin/env sh
ATTEMPTS_MAX_COUNT=40
TIMEOUT=10

ATTEMPT=1
while [ "$ATTEMPT" -le "$ATTEMPTS_MAX_COUNT" ]; do
  if [ "$(curl -sL -w '%{http_code}' http://localhost:6306/ping -o /dev/null)" = "200"]; then
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
