_igit_delete(){

    local branch
    while branch=$(
        git branch |
        egrep -v "\*|origin/HEAD" |
        cut -b 3- |
        _fzf_for_igit --multi --expect=enter \
        --preview 'git diff --color=always {}'); do

        if [[ -z $branch ]]; then
            return 0
        fi

        local cmd=$(sed -n 1P <<< "$branch")
        local br=(`awk 'NR>1{print $1}' <<< "$branch"`)

        if [[ -z $cmd ]]; then
            return 0
        fi

        print -z "git branch -D $br"
        break
    done
}
