#!/usr/bin/env bash
# shellcheck disable=SC2317
#  PURPOSE: Install KubeDB on a Kubernetes cluster.
# -----------------------------------------------------------------------------
#  PREREQS: a) configure the AppsCode Helm repo
#           b) Request the per-cluster license file.
#               https://license-issuer.appscode.com
#               Save to some place outside of the project repo
#           c) Iron Bank: there are further instructions for private registries
#               these are all config opts:
#               https://github.com/kubedb/installer/tree/v2023.08.18/charts/kubedb#configuration
# -----------------------------------------------------------------------------
#  EXECUTE:
# -----------------------------------------------------------------------------
#     TODO: 1) Starting with minikube -> EKS
#           2)
#           3)
# -----------------------------------------------------------------------------
#   AUTHOR: Todd E Thomas
# -----------------------------------------------------------------------------
#  CREATED: 2023/10/05
# -----------------------------------------------------------------------------
set -x


###----------------------------------------------------------------------------
### VARIABLES
###----------------------------------------------------------------------------
# ENV Stuff
#: "${1?  Wheres my first agument, bro!}"
versKubeDB='v2023.08.18'
NS='demo'

# Data
dirLicense="$HOME/Downloads/kubedb"
fileLicense="${dirLicense}/kubedb-enterprise-license-95757740-4821-46c7-ba0c-e8b085f5bd38.txt"


###----------------------------------------------------------------------------
### FUNCTIONS
###----------------------------------------------------------------------------
function pMsg() {
    theMessage="$1"
    printf '%s\n' "$theMessage"
}


###----------------------------------------------------------------------------
### MAIN PROGRAM
###----------------------------------------------------------------------------
### Install KubeDB
###   NOTE: the community edition is not maintained very well; it's over a year
###         old and errors when following the instructions.
###---
helm install kubedb appscode/kubedb \
    --version "$versKubeDB" \
    --namespace kubedb --create-namespace \
    --set kubedb-provisioner.enabled=true \
    --set kubedb-ops-manager.enabled=true \
    --set kubedb-autoscaler.enabled=true \
    --set kubedb-dashboard.enabled=true \
    --set kubedb-schema-manager.enabled=true \
    --set-file global.license="$fileLicense"


###---
### Wait for pods to complete before proceeding
###---
pMsg "Waiting for KubeDB to finish installation..."
kubectl -n kubedb wait --for=condition=ready pod \
    -l "app.kubernetes.io/instance=kubedb"


###---
### Print available CRDs
###---
pMsg "These CRDs are now available on the system..."
kubectl get crd -l app.kubernetes.io/name=kubedb




###---
### Create Demo
###---


###---
### Send pgAdmin to the cluster
###---
kubectl create -f addons/kubedb/pgadmin.yaml

# From: https://raw.githubusercontent.com/kubedb/docs/v2023.08.18/docs/examples/postgres/quickstart/pgadmin.yaml

###---
### Collect the address and port info
###---
mkIPAddr="$(mikube ip)"
nodePort="$(kubectl -n demo get service/pgadmin -o=jsonpath='{.spec.ports[].nodePort}')"

# For example:
# http://${mkIPAddr}:${NodePort} would expand to something like:
# http://192.168.49.2:32248


###---
### Let's go see what's out there
###---
minikube service pgadmin -n demo --url "http://${mkIPAddr}:${nodePort}"&


###---
### REQ
###---
pMsg "Now, follow the URL and open a new Terminal window to continue working"


###---
### REQ
###---


###---
### REQ
###---


###---
### REQ
###---


###---
### fin~
###---
exit 0
