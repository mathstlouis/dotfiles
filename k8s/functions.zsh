function kinspect() {
        local ns=${1}
        local nsarg=""

        if [[ ${ns} != "" ]]; then
                nsarg="--namespace=${ns}"
        fi

        kubectl run --rm -i -t mathstlouis --image=gcr.io/google-containers/toolbox --restart=Never --labels 'sidecar.istio.io/inject=false' ${nsarg} --command /bin/bash
}

function kinspectb() {
        local ns=${1}
        local nsarg=""

        if [[ ${ns} != "" ]]; then
                nsarg="--namespace=${ns}"
        fi

        kubectl run --rm -i -t mathstlouis --image=gcr.io/corp-prod-gkeinfra/busybox:1.32 --restart=Never --labels 'sidecar.istio.io/inject=false' ${nsarg} --command /bin/sh
}

function kgK() {
        kubectl get Kustomization -n flux-system -o json | jq -r '.items[] |[.metadata.name,.spec.suspend,.status.conditions[0].lastTransitionTime,.status.conditions[0].message] | @tsv' | column -ts $'\t'
}

function im() {
  kubectl get pods -n "$1" -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' |\
  sort
}
