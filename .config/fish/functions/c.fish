set -g cheat_dir "$HOME/locus/cheat/c"

# editor command
set -g editor_command emacs
# set -g editor_command "emacs -nw"
# set -g editor_command $EDITOR
set -g ed (echo $editor_command | string split ' ')[1]
set -g ed_opts (echo $editor_command | string split ' ')[2..]

# helptext
set -g usage "$(basename (status -f)) [OPTION] [CHEAT NAME/SEARCH TERM] -- Fish function to manage my cheatsheets

usage:
If ran without any argument it'll list all available cheat files.

config:
cheat_dir $cheat_dir

options:
-h  show this help text
-s  search for text in all cheat files
-e  edit/create a cheat with $editor_command. Only one file can be edited at a time.

notes:
- Currently only org files supported
- Filenames w spaces are not tested."


function c --description 'alias view and edit cheatsheet' -a opt
    argparse -X 1 h/help e/edit s/search -- $argv
    or return 0

    if set -q _flag_help
        echo $usage
        return 0
    end

    if set -q _flag_edit
        if not set -q argv[1]
            pushd $cheat_dir
            set -l cheats (ls |  xargs basename -s ".org")
            set argv (string split " " $cheats | fzf)
            popd
        end
        set -l c_path $cheat_dir/$argv.org
        touch "$c_path"

        command $ed $ed_opts $c_path
        return 0
    end

    if set -q _flag_search
        pushd $cheat_dir
        rg -g "*.org" $argv
        popd
        return 0
    end

    if not set -q argv[1]
        pushd $cheat_dir
        set -l cheats (ls |  xargs basename -s ".org")
        set argv (string split " " $cheats | fzf)
        popd
    end

    if set -q argv[1]
        set -l final_cheat_path "$cheat_dir/$argv.org"
        if not test -e $final_cheat_path
            read -l -P 'no cheat available locally, fetch from internets? [y/N] ' confirm
            switch $confirm
                case Y y
                    curl cheat.sh/$argv | bat --style=plain
                    return 0
                case '' N n
                    return 1
            end
        end
        pandoc --wrap=none --from=org --to=gfm $final_cheat_path | glow -p
        return 0
    end
end
