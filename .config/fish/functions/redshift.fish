function redshift --wraps='wlsunset -l 26.1445 -L 91.7362 &' --description 'alias redshift wlsunset -l 26.1445 -L 91.7362 &'
  wlsunset -l 26.1445 -L 91.7362 > /dev/null 2>&1 &;
end
