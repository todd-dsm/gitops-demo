#!/usr/bin/env bash
# shellcheck disable=SC2317
#  PURPOSE: Install KubeDB on a Kubernetes cluster.
# -----------------------------------------------------------------------------
#  PREREQS: a)
#           b)
#           c)
# -----------------------------------------------------------------------------
#  EXECUTE:
# -----------------------------------------------------------------------------
#     TODO: 1) Starting with minikube -> EKS
#           2) Iron Bank: there are further instructions for private registries
#               these are all config opts:
#               https://github.com/kubedb/installer/tree/v2023.08.18/charts/kubedb#configuration
# -----------------------------------------------------------------------------
#   AUTHOR: Todd E Thomas
# -----------------------------------------------------------------------------
#  CREATED: 2023/10/05
# -----------------------------------------------------------------------------
#set -x

###----------------------------------------------------------------------------
### VARIABLES
###----------------------------------------------------------------------------
# ENV Stuff
#: "${emailID?  There appears to be no eamil EXPORTed to the environment, exiting!}"
#versKubeDB='v2023.08.18'
deploymentTmpl='addons/kubedb/tmpls/pgadmin.tmpl'
kubeManifest='/tmp/pgadmin.yaml'
export myNS='demo'

# Data


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
### Create a manifest from a template file
###---
cat $deploymentTmpl | envsubst > "$kubeManifest"


###---
### Send pgAdmin to the cluster
###---
kubectl apply -f "$kubeManifest"

# From: https://raw.githubusercontent.com/kubedb/docs/v2023.08.18/docs/examples/postgres/quickstart/pgadmin.yaml


###---
### Collect the address and port info
###---
mkIPAddr="$(minikube ip)"
nodePort="$(kubectl -n demo get service/pgadmin -o=jsonpath='{.spec.ports[].nodePort}')"

# For example:
# http://${mkIPAddr}:${NodePort} would expand to something like:
# http://192.168.49.2:32248


###---
### Announce
###---
pMsg ""
pMsg ""
pMsg "Now, follow the URL and open a new Terminal window to continue working"
pMsg ""
pMsg ""


###---
### Let's go see what's out there
### FIXME: move this (L60-L85) to the end of the entire run
###---
minikube -n "$myNS" service pgadmin --url "http://${mkIPAddr}:${nodePort}"&


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
