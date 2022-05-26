function wifinetworks --wraps='iwctl station wlan0 get-networks' --description 'alias wifinetworks iwctl station wlan0 get-networks'
  iwctl station wlan0 get-networks $argv; 
end
