function ocr --wraps='grim -g $(slurp) - | tesseract stdin stdout | wl-copy' --description 'alias ocr=grim -g $(slurp) - | tesseract stdin stdout | wl-copy'
  grim -g $(slurp) - | tesseract stdin stdout | wl-copy $argv
        
end
