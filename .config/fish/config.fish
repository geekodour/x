if status is-interactive
  # see https://www.funtoo.org/Keychain
  keychain --eval --quiet --quick --nogui id_ed25519 | source
end

# sway
if test (tty) = "/dev/tty1"
  sway
end

# exports
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -x DOOMDIR "~/.config/doom"

source ~/.config/nnn/init # nnn
source ~/.config/cheat/init # cheat
source ~/.config/starship/init # starship
source /opt/asdf-vm/asdf.fish # asdf
source ~/.config/zoxide/init # zoxide

# aliases
# note:
# - zoxide: usually it is the norm to use fish functions as aliases but in the
#   specific case of zoxide, we need to define it here because of some loading
#   ordering issue.
#   see: https://github.com/ajeetdsouza/zoxide/issues/145
alias cd z
