function mostused --description="alias Show most used commands"
  history | awk '{print $1}' | sort | uniq -c | sort -rn | head
end
