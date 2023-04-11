# NOTE: you might need to run sudo mandb if cache not updated
function sman --wraps='man -k' --description 'alias man page search'
  man -k $argv
        
end
