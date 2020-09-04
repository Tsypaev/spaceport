#!/usr/bin/env sh
ATTEMPTS_MAX_COUNT=5
TIMEOUT=30
ATTEMPT=1
while [ "$ATTEMPT" -le "$ATTEMPTS_MAX_COUNT" ]; do
  if [ "$(curl 'http://localhost:6307/rules/list' -H 'masterApiKey: 123' | jq length)" = "9" ]; then
      sleep 2m;
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

docker run --network=host -v "/$(pwd)/etc/properties/gateway-client/logs:/etc/hercules" vstk/hercules-gateway-client:0.38.0-SNAPSHOT
docker run --network=host -v "/$(pwd)/etc/properties/gateway-client/metrics:/etc/hercules" vstk/hercules-gateway-client:0.38.0-SNAPSHOT
docker run --network=host -v "/$(pwd)/etc/properties/gateway-client/traces:/etc/hercules" vstk/hercules-gateway-client:0.38.0-SNAPSHOT

ATTEMPTS_MAX_COUNT=5
TIMEOUT=20
ATTEMPT=1
while [ "$ATTEMPT" -le "$ATTEMPTS_MAX_COUNT" ]; do
  if [ "$(curl localhost:9200/test-index*/_count | jq .count)" = "1" ]; then
      echo "Succes find log in Elasticsearch"
      break;
  fi;
  echo "$ATTEMPT attempt failed."

  if [ "$ATTEMPT" -eq "$ATTEMPTS_MAX_COUNT" ]; then
      echo "Can't find log in Elastcsearch"
      exit 1;
  fi;

  ATTEMPT=$(($ATTEMPT+1))
  sleep $TIMEOUT;
done

ATTEMPTS_MAX_COUNT=5
TIMEOUT=10
ATTEMPT=1
while [ "$ATTEMPT" -le "$ATTEMPTS_MAX_COUNT" ]; do
  if [ "$(curl localhost:6304/metrics/find?query=TestValue* | jq .[0].leaf)" = "1" ]; then
      echo "Succes find metric in Graphite"
      break;
  fi;
  echo "$ATTEMPT attempt failed."

  if [ "$ATTEMPT" -eq "$ATTEMPTS_MAX_COUNT" ]; then
      echo "Can't find metric in Graphite"
      exit 1;
  fi;

  ATTEMPT=$(($ATTEMPT+1))
  sleep $TIMEOUT;
done

