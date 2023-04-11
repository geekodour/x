function pserver --wraps='python3 -m http.server' --description 'alias Launch a basic python server'
  python3 -m http.server $argv
        
end
