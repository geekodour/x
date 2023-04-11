function ssman --wraps='man -k' --description 'alias Strict man page search'
  man -k $argv | rg "^$argv"
        
end
