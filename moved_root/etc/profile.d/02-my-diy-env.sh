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

            __xfl_detect_command_completion_common_setup() {
                __tmp_cmd_name="$1"
                command -v "${__tmp_cmd_name}" &> /dev/null && source <($__tmp_cmd_name completion bash)
            }

            __xfl_detect_command_completion_common_setup kubectl
            __xfl_detect_command_completion_common_setup helm
            __xfl_detect_command_completion_common_setup cilium
            __xfl_detect_command_completion_common_setup minikube
            __xfl_detect_command_completion_common_setup kind
            __xfl_detect_command_completion_common_setup kustomize
            __xfl_detect_command_completion_common_setup k3s
            __xfl_detect_command_completion_common_setup pnpm

            unset __xfl_detect_command_completion_common_setup

            command -v jbang &> /dev/null && source <(jbang completion -o)
            command -v npm &> /dev/null && source <(npm completion)
            command -v uv &> /dev/null && source <(uv generate-shell-completion bash)
            if command -v register-python-argcomplete &> /dev/null; then
                if command -v pipx &> /dev/null; then
                    source <(register-python-argcomplete pipx)
                fi
            fi

        fi
    }
    export -f XFL_BASH_INIT_FUNC

    ## 食用姿势
    ## 添加如下代码到  ~/.bashrc
    # if declare -F XFL_BASH_INIT_FUNC > /dev/null 2>&1; then
    #     XFL_BASH_INIT_FUNC
    # fi
fi

