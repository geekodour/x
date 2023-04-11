function wifinetworks --wraps='iwctl station wlan0 get-networks' --description 'alias List scanned networks'
  iwctl station wlan0 get-networks $argv; 
end
