# writing this while i listen to remote control by KW
# note: i use yadm as my dotfiles manager, it uses git. git does not allow you
#       to include another git repo in itself except some michael jackson submodule
#       moves. i am in no mood to do that dance.
#       ~/.emacs.d is a git repo and it probably needs to be a git repo based
#       on how doom emacs updates etc works. I am not sure but it'll take me
#       sometime to be sure of that because i am just getting started with doom
#       emacs. Till then, this little fish fucntion is my dirty hack to copy
#       the emacs config into a different directory and will let yadm manage
#       that directory. So in effect, the place of the emacs config file in the
#       yadm managed repo is not the actual path, the files should be in
#       ~/.emacs.d
# see: https://github.com/TheLocehiliosan/yadm/issues/361

function yadmemacs --description 'add emacs config to yadm'
  # copy tempory emacs config
  cp ~/.emacs.d/init.el ~/.config/emacsconfigtemp/
  cp ~/.emacs.d/early-init.el ~/.config/emacsconfigtemp/
  
  # add emacs files to yadm
  yadm add ~/.doom.d/
  yadm add ~/.config/emacsconfigtemp/
  yadm commit -m "updated emacs config"
end

