function wifiinfo --wraps='iwctl station wlan0 show' --description 'alias Info about current network'
  iwctl station wlan0 show $argv; 
end
