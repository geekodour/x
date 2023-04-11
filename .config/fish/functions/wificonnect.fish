function wificonnect --wraps='iwctl station wlan0 connect' --description 'alias Connect to a network'
  iwctl station wlan0 connect $argv; 
end
