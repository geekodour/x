function chatgpt-anki-prompt --wraps='cat ~/notes/org/anki/chat_gpt_anki_prompt.txt | wl-copy' --description 'alias Copy ChatGPT Prompt for generating Anki cards'
  cat ~/notes/org/anki/chat_gpt_anki_prompt.txt | wl-copy $argv
        
end
