default: install

alias f := format
alias fmt := format

format:
    just --fmt --unstable

install:
    #!/usr/bin/env bash
    set -euxo pipefail
    distro=$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)
    if [ "$distro" = "fedora" ]; then
        variant=$(awk -F= '$1=="VARIANT_ID" { print $2 ;}' /etc/os-release)
        if [ "$variant" = "toolbx" ]; then
            sudo dnf --assumeyes install awesome-vim-colorschemes vim
        elif [ "$variant" = "iot" ] || [[ "$variant" = *-atomic ]]; then
            sudo rpm-ostree install --idempotent awesome-vim-colorschemes vim
            echo "Reboot to finish installation."
        fi
    fi
    mkdir --parents "{{ config_directory() }}/vim"
    ln --force --relative --symbolic vimrc "{{ config_directory() }}/vim/vimrc"
