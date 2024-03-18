function kinspect() {
        local ns=${1}
        local nsarg=""

        if [[ ${ns} != "" ]]; then
                nsarg="--namespace=${ns}"
        fi

        kubectl run --rm -i -t mathstlouis --image=gcr.io/google-containers/toolbox --restart=Never --labels 'sidecar.istio.io/inject=false' ${nsarg} --command /bin/bash
}
