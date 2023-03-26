function pserver --wraps='python3 -m http.server' --description 'alias pserver=python3 -m http.server'
  python3 -m http.server $argv
        
end
