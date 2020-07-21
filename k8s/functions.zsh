function kinspect() {
        local ns=${1}
        local nsarg=""

        if [[ ${ns} != "" ]]; then
                nsarg="--namespace=${ns}"
        fi

        kubectl run --rm -i -t mathstlouis --image=gcr.io/google-containers/toolbox --restart=Never --labels 'sidecar.istio.io/inject=false' ${nsarg} --command /bin/bash
}

function cluster-switch() {
        local cluster=${1}

        if [[ ${cluster} == "" ]]; then
                cluster=$(set -o pipefail && kubectl config get-contexts | tail -n +2 | awk '{ print $1; }' | fzf)
        fi

        if [[ ${cluster} == "" ]]; then
                echo "no cluster provided."
                return 1
        fi

        # idx=$(kubectl config get-contexts --no-headers | grep -n ${cluster} | cut -d':' -f1)
        # helm_port=$((44000 + ${idx}))

        local session_name=shell-${cluster}

        if tmux list-session | cut -d':' -f1 | grep ${session_name}; then
                tmux switch-client -t ${session_name}
                return
        fi

        local dir=~/.config/my-kubeconfig/
        mkdir -p ${dir}
        local kubeconfig=${dir}/${cluster}-config
        local startup_script=${dir}/startup-script.sh
        cp ~/.kube/config ${kubeconfig}

        cat <<-EOT >${startup_script}
export KUBECONFIG=${kubeconfig}
kubectl config use-context ${cluster}
#export HELM_HOST="localhost:${helm_port}"
#nohup ~/.helm/plugins/helm-tiller/bin/tiller --storage=secret --listen=localhost:${helm_port} &
zsh
EOT
        chmod +x ${startup_script}

        tmux new-session -d -s ${session_name} ${startup_script}
        tmux setenv -t ${session_name} KUBECONFIG ${kubeconfig}
        # tmux setenv -t ${session_name} HELM_HOST localhost:${helm_port}
        tmux switch-client -t ${session_name}
}
alias csw=cluster-switch
