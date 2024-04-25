#!/bin/bash

# Fetch namespace
export NAMESPACE=$(kubectl get cm -A --field-selector=metadata.name=spotinst-kubernetes-cluster-controller-config -o jsonpath='{.items[0].metadata.namespace}')

# Set pipefail
set -o pipefail

# Extract Spotinst token and account
export SPOTINST_TOKEN=$(kubectl get secret -n $NAMESPACE spotinst-kubernetes-cluster-controller -o jsonpath='{.data.token}' | base64 -d 2>&1 || kubectl get cm -n $NAMESPACE spotinst-kubernetes-cluster-controller-config -o jsonpath='{.data.spotinst\.token}' 2>&1)
export SPOTINST_ACCOUNT=$(kubectl get secret -n $NAMESPACE spotinst-kubernetes-cluster-controller -o jsonpath='{.data.account}' | base64 -d 2>&1 || kubectl get cm -n $NAMESPACE spotinst-kubernetes-cluster-controller-config -o jsonpath='{.data.spotinst\.account}' 2>&1)

# Extract Spotinst cluster identifier
export SPOTINST_CLUSTER_IDENTIFIER=$(kubectl get cm -n $NAMESPACE spotinst-kubernetes-cluster-controller-config -o jsonpath='{.data.spotinst\.cluster-identifier}')

# Scale down old spotinst-kubernetes-cluster-controller deployment
kubectl scale deployment --replicas=0 -n $NAMESPACE spotinst-kubernetes-cluster-controller

# Run Spotinst init script
curl -fsSL https://spotinst-public.s3.amazonaws.com/integrations/kubernetes/cluster-controller-v2/scripts/init.sh | \
SPOTINST_TOKEN=$SPOTINST_TOKEN \
SPOTINST_ACCOUNT=$SPOTINST_ACCOUNT \
SPOTINST_CLUSTER_IDENTIFIER=$SPOTINST_CLUSTER_IDENTIFIER \
ENABLE_OCEAN_METRIC_EXPORTER=false \
ENABLE_OCEAN_NETWORK_CLIENT=false \
INCLUDE_METRIC_SERVER=false \
bash
