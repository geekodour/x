function wificonnect --wraps='iwctl station wlan0 connect' --description 'alias wificonnect iwctl station wlan0 connect'
  iwctl station wlan0 connect $argv; 
end
