#!/bin/bash
set -e

kubectl config use-context kind-kind

helm uninstall vault
kind delete cluster
