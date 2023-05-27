function git-entr --wraps=entr --description 'alias run entr on git-ls w new files'
    git ls-files -cdmo --exclude-standard | entr -d -c $argv
end
