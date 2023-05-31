function traverse_and_push
   if test -z "$argv"
       return
   end

   for repo in $argv;
    pushd $repo
    if test -d .git
        set_color green; echo "Found a git repo: $repo, will attempt pushing changes"
        set_color normal;
        git add -A
        git commit -m "auto: automated push by push_everything"
        git push origin main
    else
       set -l dirs $(ls)
       traverse_and_push $dirs
    end
    popd
   end
end

function push_everything --description 'push personal repos to gh'
    pushd ~
    set -l trees locus infra faafo
    for t in $trees;
        pushd $t
        set -l dirs $(ls)
        traverse_and_push $dirs
        popd
    end
    popd
end
