function wifiscan --wraps='iwctl station wlan0 scan' --description 'alias wifiscan iwctl station wlan0 scan'
  iwctl station wlan0 scan $argv; 
end
