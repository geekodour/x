function chatgpt-anki-prompt --wraps='cat' --description 'alias Copy ChatGPT Prompt for generating Anki cards'
    cat ~/locus/anki/chat_gpt_anki_prompt.txt | wl-copy $argv

end
