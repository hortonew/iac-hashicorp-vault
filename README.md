# Infrastructure as Code (IAC): Hashicorp Vault

This repository is a collection of ways to configure Hashicorp Vault in code.

I decided to make the setup of Vault a bit more complex than just running the binary because future iterations may expand on the infrastructure.  Here we use [kind](https://kind.sigs.k8s.io/) to simulate a kubernetes environment and helm to deploy Vault.

The different ways to configure Vault as code are defined as "labs" below.  Each lab will be a self-contained way of configuring a specific aspect of Vault.  They can all be combined into one configuration, but it's good to isolate each concern for learning purposes.

## Prerequisites

- [kind](https://kind.sigs.k8s.io/)
- [helm](https://helm.sh)
- [vault helm chart](https://github.com/hashicorp/vault-helm)
- [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [jq](https://jqlang.github.io/jq/)

## Quickstart

This will set up a kubernetes cluster with kind, install Vault using helm, and port forward port 8200 into the cluster.

```sh
./bootstrap.sh
```

## Labs

[Authenticate with Okta](terraform/oidc-auth-with-okta/README.md)

## Clean up

```sh
./destroy.sh
```
