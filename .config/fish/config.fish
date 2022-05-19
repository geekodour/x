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

source ~/.config/nnn/init # nnn
source ~/.config/cheat/init # cheat
source ~/.config/starship/init # starship
source /opt/asdf-vm/asdf.fish # asdf
