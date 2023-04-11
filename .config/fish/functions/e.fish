# see https://wiki.archlinux.org/title/emacs#As_a_systemd_unit
function e --wraps='emacsclient -nc' --description 'alias emacsclient'
  emacsclient -nc $argv; 
end
