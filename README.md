# Infrastructure as Code (IAC): Hashicorp Vault

This repository is a collection of methods to manage Hashicorp Vault in code.

## Prerequisites

- [kind](https://kind.sigs.k8s.io/) (Kubernetes in Docker)
- [helm](https://helm.sh)
- [vault helm chart](https://github.com/hashicorp/vault-helm)
- [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Configure a kubernetes cluster

Modify kind_config.yaml with as many/little control plane and worker nodes as you want to work with.

`kind create cluster --config k8s/kind_config.yaml`

## Configure Vault

Set up a dev instance of Vault using helm.  This will create a single pod where Vault is already unsealed.

```sh
# Set up dev cluster
kind create cluster --config k8s/kind_config.yaml

# Set up dev vault install
helm install vault hashicorp/vault --version 0.25.0 --values k8s/dev_values.yaml

### Set up a port-forward into your cluster
kubectl port-forward svc/vault 8200:8200
```

## Labs

[Authenticate with Okta](terraform/oidc-auth-with-okta/README.md)

## Clean up

```sh
# To remove Vault
helm uninstall vault

# To delete the kind cluster
kind delete cluster
```
