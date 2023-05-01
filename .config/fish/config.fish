# DO NOT EDIT config.fish
# file tangled from config.org
# EDIT config.org and then tangle

if status is-interactive
    keychain --eval --quiet --quick --nogui $SSH_KEYS_TO_AUTOLOAD | source # ssh
    keychain --eval --quiet --quick --nogui --agents gpg "$GPG_FP_TO_AUTOLOAD" | source # gpg
end

# see https://stackoverflow.com/questions/51504367/gpg-agent-forwarding-inappropriate-ioctl-for-device
set -x GPG_TTY $(tty)

if test (tty) = /dev/tty1
    sway
end

set -g direnv_fish_mode eval_on_arrow # sourced direnv hook

set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -x DOOMDIR "~/.config/doom"
set -x EDITOR nvim

# NOTE: I am not sure if these are necessary when we use asdf
# NOTE: deal w npm beleg ke.
set -x CARGO_HOME $XDG_DATA_HOME/cargo
set -x GEM_HOME $XDG_DATA_HOME/gem
set -x GOPATH $XDG_DATA_HOME/go # what aboout someone saying no need to set gopath
set -x NIMBLE_DIR $XDG_DATA_HOME/nimble
set -x NODE_REPL_HISTORY $XDG_DATA_HOME/node_repl_history

set -x LESSHISTFILE $XDG_STATE_HOME/less/history

source ~/.config/nnn/init # nnn
source ~/.config/starship/init # starship
source /opt/asdf-vm/asdf.fish # asdf
source ~/.config/zoxide/init # zoxide

alias cd z
