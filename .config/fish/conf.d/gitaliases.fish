# note: usually aliases are defined under the ~/.config/fish/functions
#       directory but because there will be huge number of git aliases, i
#       decided to keep them separate in a file. The issue with this approach
#       is that it'll not lazy load these aliases, so make sure not to add slow
#       aliases here otherwise it'll affect shell startup time. (still need to
#       confirm this)
# see: https://github.com/k88hudson/git-flight-rules
# see: https://github.com/git-tips/tips

function gitaliases --wraps='alias' --description 'alias (git): show this'
  alias | rg '(git)'
end

function gd --wraps='git diff' --description 'alias (git): short for git diff'
  clear; git diff $argv; 
end

function gdp --wraps='git --no-pager diff' --description 'alias (git): no pager diff'
  git --no-pager diff $argv; 
end


function gs --wraps='git status' --description 'alias (git): short for git status'
  clear; git status $argv; 
end

function gdsum --description 'alias (git): print summary of the diff'
  git diff --compact-summary;
end

function gl --wraps='git log --pretty=oneline --abbrev-commit' --description 'alias (git): one-line git log'
  git log --pretty=oneline --abbrev-commit;
end

function gremotes --wraps='git remove -v' --description 'alias (git): list all git remotes'
  git remote -v;
end

function grepos --wraps='gfold' --description 'alias (git): gfold, show repos under curdir'
  gfold
end

function grsum --wraps='onefetch' --description 'alias (git): print summary of git repo'
  onefetch; tokei;
end
