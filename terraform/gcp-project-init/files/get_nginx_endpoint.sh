#!/bin/bash

ENDPOINT="$(kubectl --context=$1 get service -n nginx-ingress -o jsonpath='{.items[?(@.spec.type=="LoadBalancer")].status.loadBalancer.ingress[0].ip}')"

jq -n --arg endpoint "$ENDPOINT" '{"endpoint": $endpoint}'