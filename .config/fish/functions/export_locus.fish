function export_locus --description 'export most of locus'
  pushd ~/locus
  set -l repos_to_export blog diary mogoz o todayi cheat
  for r in $repos_to_export;
      pushd $r
      echo "exporting repos ~/locus/$r"
      make export
      echo "done exporting repos ~/locus/$r"
      popd
  end
  popd
end
