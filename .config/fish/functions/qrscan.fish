function qrscan --wraps='grim -g $(slurp) - | zbarimg --raw - | wl-copy' --description 'alias Screenshot QRscan'
  grim -g $(slurp) - | zbarimg --raw - | wl-copy $argv
        
end
