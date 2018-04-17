#!/usr/bin/env bash

if [ -z "$1" ]
then
  echo "Node name cannot be empty"
  exit 1
else
  hostname=$(kubectl get node $1 -o jsonpath="{.status.addresses[?(.type=='ExternalDNS')].address}")
  ssh -i ${KUBECTL_PLUGINS_LOCAL_FLAG_IDENTITY_FILE} ${KUBECTL_PLUGINS_LOCAL_FLAG_SSH_USER}@$hostname
fi
