#!/bin/bash

set -o errexit
set -o pipefail

# New Relic
service_name="datagov-harvest-secrets"
path=".credentials.NEW_RELIC_LICENSE_KEY"
export NEW_RELIC_LICENSE_KEY=$(echo $VCAP_SERVICES | jq --raw-output --arg service_name "$service_name" ".[][] | select(.name == \$service_name) | $path")
