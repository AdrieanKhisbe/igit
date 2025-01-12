
_igit_stash() {

    local stash

    while stash=$(
        git stash list |
        _fzf_for_igit +m --expect=ctrl-s,alt-a,alt-d \
        --header "ctrl-s: see diff, alt-a: apply selected stash, alt-d: drop selected stash" \
        --preview 'git diff --color=always {1}'); do
        
        if [[ -z $stash ]]; then
            return 0
        fi

        local cmd=$(sed -n 1P <<< "$stash")
        local st=$(sed -n 2P <<< "$stash")

        if [[ -z $cmd ]]; then
            return 0
        fi

        local name=$(awk -F ':' {'print $1'} <<< "$st")
        if [ $cmd = ctrl-s ]; then
            git diff --color=always $name | less -R
        elif [ $cmd = alt-a ]; then
            print -z "git stash apply $name"
            break
        elif [ $cmd = alt-d ]; then
            print -z "git stash drop $name"
            break
        else
            break
        fi
    done

}
