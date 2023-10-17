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
#     DOCS: https://github.com/kubedb/docs/tree/master/docs/examples/postgres
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
: "${emailID?  There appears to be no eamil EXPORTed to the environment, exiting!}"
#versKubeDB='v2023.08.18'
deploymentTmpl='addons/kubedb/tmpls/pgadmin.tmpl'
kubeManifest='/tmp/pgadmin.yaml'
export myNS='demo'

# Data
rawManifest='https://github.com/kubedb/docs/raw/v2023.08.18/docs/examples/postgres/quickstart/quick-postgres.yaml'
export outputDir='/tmp/postgres'
export fileName="${rawManifest##*/}"
export kubeManifest="${outputDir}/${fileName}"


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
### Create pgAdmin manifest from a template file
###---
cat $deploymentTmpl | envsubst > "$kubeManifest"


###---
### Send pgAdmin to the cluster
###---
kubectl apply -f "$kubeManifest"

# From: https://raw.githubusercontent.com/kubedb/docs/v2023.08.18/docs/examples/postgres/quickstart/pgadmin.yaml

###---
### Wait for it...
###---
kubectl -n "$myNS" wait --for=condition=Ready=true --timeout='30s' \
   pod -l app=pgadmin


###---
### Collect the address and port info: USUALLY NOT NECESSARY
###---
#mkIPAddr="$(minikube ip)"
#nodePort="$(kubectl -n "$myNS" get service/pgadmin -o=jsonpath='{.spec.ports[].nodePort}')"

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
minikube -n "$myNS" service pgadmin --url&


###----------------------------------------------------------------------------
### Create a PostgreSQL database
### REF: https://kubedb.com/docs/v2023.08.18/guides/postgres/quickstart/quickstart/#create-a-postgresql-database
###----------------------------------------------------------------------------
### Fetch a Manifest
###---
curl -L --create-dirs -O --output-dir "$outputDir" "$rawManifest"

### Change the namespace
#if [[ "$myNS" == 'demo' ]]; then
#    sed -i 's/demo/yo/g' "$kubeManifest"
#fi

### modify terminationPolicy for demo
sed -i '/terminationPolicy/ s/DoNotTerminate/Delete/g' "$kubeManifest"


###---
### Send it...
###---
kubectl apply -f "$kubeManifest"


###---
### Wait for it...
###---
kubectl -n "$myNS" wait --for=condition=Ready=true --timeout='30s' \
   pod -l app=pgadmin


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
### REQ
###---


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
