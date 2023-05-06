_hostsctl_list() {
    local cur prev words
    _get_comp_words_by_ref cur prev words

    local options='--help --no-pager --no-legend'

    if [[ "$cur" == -* ]]; then
        mapfile -t COMPREPLY < <(compgen -W "${options}" -- "$cur")
        return
    fi
}

_hostsctl_options() {
    local cur prev words
    _get_comp_words_by_ref cur prev words

    local options='--help'

    if [[ "$cur" == -* ]]; then
        mapfile -t COMPREPLY < <(compgen -W "${options}" -- "$cur")
        return
    fi
}


_hostsctl() {
    local cur prev words
    _get_comp_words_by_ref cur prev words

    local actions='list add remove set-hostname add-alias remove-alias'
    local options='--help --man --version --file --host'

    local word
    for word in "${words[@]}"; do
        case $word in
            list)
                _hostsctl_list
                return
                ;;
            add|remove|set-hostname|add-alias|remove-alias)
                _hostsctl_options
                return
                ;;
        esac
    done


    case "$prev" in
        --file)
            _filedir
            return
            ;;
        --host)
            _known_hosts_real -a "$cur"
            return
            ;;
        --help|--man|--version)
            return
            ;;
    esac

    if [[ "$cur" == -* ]]; then
        mapfile -t COMPREPLY < <(compgen -W "${options}" -- "$cur")
        return
    fi

    mapfile -t COMPREPLY < <(compgen -W "${actions}" -- "$cur")

    return
}

complete -F _hostsctl hostsctl

# vim: ft=sh
