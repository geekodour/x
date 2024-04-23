function r --wraps=nnn --description 'alias r nnn'
  # -c cli opener
  # -a auto setup fifo
  # -d detail mode
  # -o open files on return key only
  # -Q disable confirmation on quit w multple act. contexts

  # NOTE: we're removing -r flag for this: https://github.com/NixOS/nixpkgs/issues/271508
  # -r show cp/mv progress 

  #nnn -adorQ $argv; 
  nnn -acdoQ $argv; 
end
