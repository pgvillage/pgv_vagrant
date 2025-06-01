#!/bin/bash
set -ex

function cluster_exists() {
  if [ ! -d "environments/${CLUSTER}" ]; then
    echo "Cannot deploy. Missing environment $PWD/environments/${CLUSTER}/"
    exit 1
  fi
}

if [ -z "${CLUSTER}" ]; then
  CLUSTER=${1:-cluster1}
fi

cd ~/git/pgvillage && cluster_exists
time ansible-playbook -i environments/${CLUSTER} functional-all.yml
