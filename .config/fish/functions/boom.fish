function boom --description 'alias Set default source/sink for sound/mic' -a flow
  if test (count $argv) -eq 1
    switch $flow
    case sink
      pactl set-default-sink $(pactl list sinks|grep Name|cut -f2 -d:|string trim|fzf)
    case source
      pactl set-default-source $(pactl list sources|grep Name|cut -f2 -d:|string trim|fzf)
    case '*'
      echo "unknown argument. should be one of sink or source."
      echo "see man pactl"
    end
  else if test (count $argv) -gt 1
    echo "only one argument accepted. should be one of sink or source."
    echo "see man pactl"
  else
    pactl info
  end
end
