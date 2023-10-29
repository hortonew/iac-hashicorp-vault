#!/bin/bash
set -e

# Create Kubernetes cluster (in docker)
kind create cluster --config k8s/kind_config.yaml
kubectl config use-context kind-kind
kubectl get nodes

# Install Vault
helm install vault hashicorp/vault --version 0.25.0 --values k8s/dev_values.yaml
while [[ $(kubectl get pod vault-0 -o=jsonpath='{.status.phase}') != "Running" ]]; do 
    echo "Waiting for vault-0 pod to be running..."
    sleep 5
done

# Background the port-forward
kubectl port-forward svc/vault 8200:8200 &

# Test
sleep 1
echo "Writing secret..."
curl -s -H "X-Vault-Token: root" -X POST -d '{"data":{"value":"bar"}}' http://127.0.0.1:8200/v1/secret/data/foo | jq '.data.version'
echo "Getting secret..."
curl -s -H "X-Vault-Token: root" http://127.0.0.1:8200/v1/secret/data/foo | jq '.data.data'
