
function cv --description 'alias Custom cheat' -a opt
    set -l usage "$(basename (status -f)) [-h] [-e] -- Manage your cheatsheets
    where:
    -h  show this help text
    -s  set the seed value (default: 42)"

    argparse -X 1 h/help 'e/edit=' -- $argv
    # echo $_flag_help
    echo $usage
    # echo $_flag_edit
    # if test (count $argv) -eq 1
    #     switch $opt
    #         case e
    #             echo "edit"
    #         case ls
    #             echo "list all"
    #         case '*'
    #             echo "unknown argument. should be one of e or ls"
    #             echo "see man pactl"
    #     end
    # else if test (count $argv) -gt 1
    #     echo "only one argument accepted. should be one of sink or source."
    #     echo "see man pactl"
    # else
    #     pactl info
    # end
end
