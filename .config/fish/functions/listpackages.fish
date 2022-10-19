function listpackages -d 'list packages installed by pacman' -a source
  if test (count $argv) -eq 1
    switch $source
    case all
      pacman -Qettq
    case aur
      pacman -Qettmq
    case official
      pacman -Qettnq
    case '*'
      echo "unknown argument. should be one of all, aur, official."
    end
  else
    echo "only one argument accepted. should be one of all, aur, official."
  end
end
