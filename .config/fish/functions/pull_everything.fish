function traverse_and_pull
   if test -z "$argv"
       return
   end

   for repo in $argv;
    pushd $repo
    if test -d .git
        set_color green; echo "Found a git repo: $repo, will attempt pulling changes"
        set_color normal;
        git pull
    else
       set -l dirs $(ls)
       traverse_and_pull $dirs
    end
    popd
   end
end

function pull_everything --description 'pull personal repos from gh'
    pushd ~
    set -l trees locus infra faafo
    for t in $trees;
        pushd $t
        set -l dirs $(ls)
        traverse_and_pull $dirs
        popd
    end
    popd
end
