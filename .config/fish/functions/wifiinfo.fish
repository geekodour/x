function wifiinfo --wraps='iwctl station wlan0 show' --description 'alias wifiinfo iwctl station wlan0 show'
  iwctl station wlan0 show $argv; 
end
