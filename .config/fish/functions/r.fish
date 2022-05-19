function r --wraps=nnn --description 'alias r nnn'
  # -c cli opener
  # -a auto setup fifo
  # -d detail mode
  # -o open files on return key only
  # -r show cp/mv progress
  # -Q disable confirmation on quit w multple act. contexts
  nnn -acdorQ $argv; 
end
