function ocr --wraps='grim -g $(slurp) - | tesseract stdin stdout | wl-copy' --description 'alias Screenshot OCR'
  grim -g $(slurp) - | tesseract stdin stdout | wl-copy $argv
        
end
