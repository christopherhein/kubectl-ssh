#!/usr/bin/env bash

if [ "$KUBECTL_PLUGINS_LOCAL_FLAG_SELECTOR" == "" ] && [ -z "$1" ]
then
  echo "Node name cannot be empty"
  exit 1
else
  if [ "$KUBECTL_PLUGINS_LOCAL_FLAG_SELECTOR" == "" ]
  then
    selector=""
    path="{.status.addresses[?(.type == 'ExternalIP')].address}"
  else
    selector="-l $KUBECTL_PLUGINS_LOCAL_FLAG_SELECTOR"
    path="{.items[0].status.addresses[?(.type=='ExternalIP')].address}"
  fi
  hostname=$(kubectl get node $1 -o jsonpath="${path}" $selector)
  [[ ! -z $hostname  ]] && ssh -i ${KUBECTL_PLUGINS_LOCAL_FLAG_IDENTITY_FILE} ${KUBECTL_PLUGINS_LOCAL_FLAG_SSH_USER}@$hostname || echo "Can't find ExternalIP"; exit 1;
fi
