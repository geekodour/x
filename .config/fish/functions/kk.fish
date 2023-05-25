# kk: konventionalkomits :)
function kk --description 'alias kk conventional commits'
    echo "<type>(optional scope): <description>"
    echo "[optional body]"
    echo "[optional footer(s)]"

    printf "\n"
    echo "types: fix,feat,chore,docs, style, refactor, perf, test etc."
    echo "scopes: api,lang etc."
    printf "\n"
    echo "Breaking change indicators:"
    echo '1. The text "BREAKING CHANGE" anywhere in the commit message'
    echo '2. "!" after type is breaking change. Eg. fix!: some description'
    printf "\n"
    echo "https://conventionalcommits.org"
    wl-copy "<type>(optional scope): <description>"
end
