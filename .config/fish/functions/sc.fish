# as of the moment this is not available from wofi but we would want to make it
# available from wofi later
function sc --wraps='grim -g 3302,603 1x1 - | swappy -f -' --description 'alias sc grim -g 3302,603 1x1 - | swappy -f -'
  grim -g $(slurp) - | swappy -f - $argv; 
end
