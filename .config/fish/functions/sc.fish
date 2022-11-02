# as of the moment this is not available from wofi but we would want to make it
# available from wofi later
function sc --wraps='grim -g $(slurp) - | swappy -f -' --description 'alias sc grim -g $(slurp) - | swappy -f -'
  grim -g $(slurp) - | swappy -f - $argv; 
end
