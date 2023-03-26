# NOTE: you might need to run sudo mandb if cache not updated
function sman --wraps='man -k' --description 'alias sman=man -k (search manpage)'
  man -k $argv
        
end
