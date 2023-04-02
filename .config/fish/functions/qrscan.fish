function qrscan --wraps='grim -g $(slurp) - | zbarimg --raw - | wl-copy' --description 'alias qrscan=grim -g $(slurp) - | zbarimg --raw - | wl-copy'
  grim -g $(slurp) - | zbarimg --raw - | wl-copy $argv
        
end
