#https://gitlab.internal.numberfour.eu/numberfour/server/web-service/-/blob/99ff6c17f2a0328b0a231720faae81ab03649a2e/scripts/kubectl_macros.sh
## Kubernetes (kubectl) functions --------------

# Finds pods using a search term
# Run using `podname <namespace> <search-term>
kpodname() {
  kubectl -n $1 get pods | grep -i "$2" | awk '{print $1;}'
}

# Find the namespace that matches a string
# Run using `findns <search-term>`
kfindns() {
  kubectl get namespaces | grep -i "$@" | awk '{print $1;}'
}

# Deletes all pods matching a given search term
# Run using `deletepod <namespace> <search-term>`
kdeletepod() {
  kubectl -n $1 delete pod `kpodname "$1" "$2"`
}

# Describes all pods matching a given search term
# Run using `descpod <namespace> <search-term>`
kdescpod() {
  kubectl -n $1 describe pod `kpodname "$1" "$2"`
}

# Watches pods for changes in a given namespace
# Run using `watchnspods <namespace>`
kwatchpod() {
  kubectl -n $1 get pods -w
}

# Gets a resource from kubernetes by `kubectl get <resource list>`
# Run using `kget <resource-list>`
# To use a namespace, run using `kget -n <namespace> <resource-list>`
kget() {
  kubectl get "$@"
}

# Finds all the pods in a given namespace using `kget` function
# Run using `npods <namespace>`
knpods() {
  kget pods -n "$@"
}

# Finds a type of resources for a given searchable namespace
# Run using `knget <namespace-search-term> <resource>`
knget() {
  kubectl -n `kfindns $1` get $2
}

# Starts tailing the logs of a pod defined in a namespace after
# looking up the name of the pod
# Run using `klogs <namespace> <podname>`
klogs() {
  local ns=$(kfindns $1)
  local pod=$(kpodname $ns $2)
  kubectl logs -f -n $ns $pod
}

# Starts tailing the logs of a pod defined in a namespace after
# looking up the name of the pod. It also takes the container name
# inside the pod for pods that have more than one container.
kclogs() {
  local ns=$(kfindns $1)
  local pod=$(kpodname $ns $2)
  kubectl logs -f -n $ns $pod $3 $4
}

# Runs fblog on klogs
fklogs() {
  klogs "$@" | fblog
}

# Runs fblog on kclogs
fkclogs() {
  kclogs "$@" | fblog
}

# Forwards porsts frmo a given pod by searching for a namespace
# and pod name from other functions
# Run using `kfwd <namespace-search-term> <podname-search-term> <port-to-forward>`
kfwd() {
  local ns=$(kfindns $1)
  local pod=$(kpodname $ns $2)
  kubectl -n $ns port-forward $pod $3:$3
}

# list all function available from this file
man_ktools() {
  cat << 'EOF'
  kpodname <namespace> <search-term> - Finds pods using a search term
  kfindns <search-term> - Find the namespace that matches a string
  kdeletepod <namespace> <search-term> - Deletes all pods matching a given search term'
  kdescpod <namespace> <search-term> - Describes all pods matching a given search term
  kwatchpod <namespace> - Watches pods for changes in a given namespace
  kget <resource-list> - Gets a resource from kubernetes by `kubectl get <resource list>`
  knpods <namespace> - Finds all the pods in a given namespace using `kget` function
  knget <namespace-search-term> <resource> - Finds a type of resources for a given searchable namespace
  klogs <namespace> <podname> - Starts tailing the logs of a pod defined in a namespace after looking up the name of the pod
  kclogs <namespace> <podname> - Starts tailing the logs of a pod defined in a namespace after looking up the name of the pod. It also takes the container name inside the pod for pods that have more than one container.
  fklogs <namespace> <podname> - Runs fblog on klogs
  fkclogs <namespace> <podname> - Runs fblog on kclogs
  kfwd <namespace-search-term> <podname-search-term> <port-to-forward> - Forwards porsts frmo a given pod by searching for a namespace and pod name from other functions
EOF
}
usage_ktools() {
  man_ktools
}
ktools_usage() {
  man_ktools
}
ktools_help() {
  man_ktools
}
help_ktools() {
  man_ktools
}
