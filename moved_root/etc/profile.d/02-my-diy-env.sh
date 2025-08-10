export LC_ALL="en_US.utf8"

export all_proxy='socks5://fq.internal:7890'
export https_proxy='http://fq.internal:7890'
export http_proxy='http://fq.internal:7890'
export no_proxy='localhost,127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,::1,fe80::/8,fd00::/8,internal,aliyuncs.com,aliyun.com,npmmirror.com'

export ALL_PROXY="$all_proxy"
export HTTPS_PROXY="$https_proxy"
export HTTP_PROXY="$http_proxy"
export NO_PROXY="$no_proxy"

if [ "$BASH" ]; then
    if [[ "$PATH" == *"/usr/local/bin"* ]]; then
        export PATH="${PATH}:/usr/local/bin"
    fi

    # set PATH so it includes user's private bin if it exists
    if [ -d "${HOME}/bin" ] && [ "$PATH" != *"${HOME}/bin"* ] ; then
        export PATH="${HOME}/bin:${PATH}"
    fi

    # set PATH so it includes user's private bin if it exists
    if [ -d "${HOME}/.local/bin" ] && [ "$PATH" != *"${HOME}/.local/bin"* ] ; then
        export PATH="${HOME}/.local/bin:${PATH}"
    fi

    # export XFL_HACK_DEBUG="yes TERM_PROGRAM=[${TERM_PROGRAM}] VSCODE_IPC_HOOK_CLI=[${VSCODE_IPC_HOOK_CLI}]"
    # if [[ ( $- == *i* || -n "$PS1" ) || ( -n "$TERM_PROGRAM" && "$TERM_PROGRAM" == "vscode" ) ]]; then
    # if [[ ( $- == *i* || -n "$PS1" ) || -n "$VSCODE_IPC_HOOK_CLI" || -n "$VSCODE_AGENT_FOLDER" ]]; then
    XFL_BASH_INIT_FUNC() {
        if [[ ( $- == *i* || -n "$PS1" ) || -n "$VSCODE_IPC_HOOK_CLI" ]]; then
            if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
                . /etc/bash_completion
            fi

            command -v kubectl &> /dev/null && source <(kubectl completion bash)
            command -v helm &> /dev/null && source <(helm completion bash)
            command -v cilium &> /dev/null && source <(cilium completion bash)
            command -v minikube &> /dev/null && source <(minikube completion bash)
            command -v kind &> /dev/null && source <(kind completion bash)
            command -v kustomize &> /dev/null && source <(kustomize completion bash)
            command -v k3s &> /dev/null && source <(k3s completion bash)
        fi
    }
    export -f XFL_BASH_INIT_FUNC

fi

