function hserve --wraps='hugo server --buildDrafts --navigateToChanged --ignoreCache' --description 'alias hserve=hugo server --buildDrafts --navigateToChanged --ignoreCache'
  hugo server --buildDrafts --navigateToChanged --ignoreCache $argv
        
end
