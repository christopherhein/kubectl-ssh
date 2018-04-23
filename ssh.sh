#!/usr/bin/env bash

if [ "$KUBECTL_PLUGINS_LOCAL_FLAG_SELECTOR" == "" ] && [ -z "$1" ]
then
  echo "Node name cannot be empty"
  exit 1
else
  if [ "$KUBECTL_PLUGINS_LOCAL_FLAG_SELECTOR" == "" ]
  then
    selector=""
    path="{.status.addresses[?(.type=='ExternalDNS')].address}"
  else
    selector="-l $KUBECTL_PLUGINS_LOCAL_FLAG_SELECTOR"
    path="{.items[0].status.addresses[?(.type=='ExternalDNS')].address}"
  fi
  hostname=$(kubectl get node $1 -o jsonpath="${path}" $selector)
  [[ -z $hostname ]] && hostname=$(kubectl get node $1 -o jsonpath="${path/ExternalDNS/ExternalIP}" $selector)
  if [[ ! -z $hostname  ]]; then
    ssh -i ${KUBECTL_PLUGINS_LOCAL_FLAG_IDENTITY_FILE} ${KUBECTL_PLUGINS_LOCAL_FLAG_SSH_USER}@$hostname
  else
    echo "Can't find Public DNS/IP"
    exit 1
  fi
fi
