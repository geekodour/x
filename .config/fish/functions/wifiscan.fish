function wifiscan --wraps='iwctl station wlan0 scan' --description 'alias Scan networks'
  iwctl station wlan0 scan $argv; 
end
