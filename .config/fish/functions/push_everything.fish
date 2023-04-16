function push_everything --description 'push personal repos to gh'
  pushd ~
  set -l trees locus infra faafo
  for t in $trees;
      echo "pushing repos under ~/$t"
      pushd $t
      set -l dirs $(ls)
      for i in $dirs;
          echo "pushing ~/$t/$i"
          pushd $i
          ls
          # git add -A
          # git commit -m "automated commit, god bless"
          # git push origin main
          popd
          printf "done pushing ~/$t/$i\n\n"
      end
      popd
  end
  popd
end
