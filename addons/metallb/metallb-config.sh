#!/usr/bin/env bash
# shellcheck disable=SC2317
#  PURPOSE: Sends a ConfigMap with usable IPs for MetalLB; only for use during
#           local Kubernetes work.
#           Provides 2 usable addresses that should be free on any system. Then,
#           any number of ports can be configured/addresses; this should be
#           adequate for general purposes.
# -----------------------------------------------------------------------------
#  PREREQS: a) Best results when Docker runtime is all defaults.
#           b)
#           c)
# -----------------------------------------------------------------------------
#  EXECUTE:
# -----------------------------------------------------------------------------
#     TODO: 1)
#           2)
#           3)
# -----------------------------------------------------------------------------
#   AUTHOR: Todd E Thomas
# -----------------------------------------------------------------------------
#  CREATED: 2021/10/00
# -----------------------------------------------------------------------------
#set -x


###----------------------------------------------------------------------------
### VARIABLES
###----------------------------------------------------------------------------
# ENV Stuff
#: "${1?  Wheres my first agument, bro!}"
export myTemplate='addons/metallb/mlb.tmpl'
export kManifest='/tmp/mlb.yaml'
export LoadBalancerStartIP='192.168.49.253'
export   LoadBalancerEndIP='192.168.49.254'

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
### Create Cluster Definition
###---
pMsg "Creating manifest from template..."
envsubst < "$myTemplate" > "$kManifest"


###---
### REQ
###---
pMsg "Sending the ConfigMap to the cluster..."
kubectl apply -f "$kManifest"


###---
### Display configuration results
###---
pMsg "These are the addresses configured for MetalLB use:"
kubectl -n metallb-system describe cm/config


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
