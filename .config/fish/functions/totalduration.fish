function totalduration --description 'alias Get total duration of all the files in the current directory'
  find . -maxdepth 1 -exec ffprobe -v quiet -of csv=p=0 -show_entries format=duration {} \; | awk '{s+=$0} END {print s/3600}'
end
