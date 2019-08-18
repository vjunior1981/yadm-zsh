_prompt_yadm_status () {
    if [ -f ~/.yadm/.status ]; then
        case $(cat ~/.yadm/.status) in
            (1)
                print -P '%B%F{magenta}There are local configuration changes. Yadm sync required.%f%b'
                ;;
            (2)
                print -P '%B%F{magenta}Run yadm push.%f%b'
                ;;
        esac
    fi
}

#
# Functions
# (sorted alphabetically)
#

function yadm_current_branch() {
    local ref
    ref=$(command yadm symbolic-ref --quiet HEAD 2> /dev/null)
    local ret=$?
    if [[ $ret != 0 ]]; then
      [[ $ret == 128 ]] && return  # no git repo.
      ref=$(command yadm rev-parse --short HEAD 2> /dev/null) || return
    fi
    echo ${ref#refs/heads/}
}

function yadm_add_all() {
    for i in $(yadm status -s|awk '{print $2}')
    do
    yadm add $i
    done
}

function yadm_add_submodule() {
    local url=$(cat "$1"/.git/config|grep -i url|cut -d'=' -f2)
    yadm submodule add "${url}" "${1}"
}

#
# Aliases
# (sorted alphabetically)
#

alias y='yadm'

alias ya='yadm add'
alias yya='yadm_add_all'
alias ys='yadm_add_submodule'
alias yapa='yadm add --patch'
alias yau='yadm add --update'
alias yav='yadm add --verbose'
alias yap='yadm apply'

alias yb='yadm branch'
alias yba='yadm branch -a'
alias ybd='yadm branch -d'
alias ybda='yadm branch --no-color --merged | command grep -vE "^(\*|\s*(master|develop|dev)\s*$)" | command xargs -n 1 yadm branch -d'
alias ybD='yadm branch -D'
alias ybl='yadm blame -b -w'
alias ybnm='yadm branch --no-merged'
alias ybr='yadm branch --remote'
alias ybs='yadm bisect'
alias ybsb='yadm bisect bad'
alias ybsg='yadm bisect good'
alias ybsr='yadm bisect reset'
alias ybss='yadm bisect start'

alias yc='yadm commit -v'
alias yc!='yadm commit -v --amend'
alias ycn!='yadm commit -v --no-edit --amend'
alias yca='yadm commit -v -a'
alias yca!='yadm commit -v -a --amend'
alias ycan!='yadm commit -v -a --no-edit --amend'
alias ycans!='yadm commit -v -a -s --no-edit --amend'
alias ycam='yadm commit -a -m'
alias ycsm='yadm commit -s -m'
alias ycb='yadm checkout -b'
alias ycf='yadm config --list'
alias ycl='yadm clone --recurse-submodules'
alias yclean='yadm clean -fd'
alias ypristine='yadm reset --hard && yadm clean -dfx'
alias ycm='yadm checkout master'
alias ycd='yadm checkout develop'
alias ycmsg='yadm commit -m'
alias yco='yadm checkout'
alias ycount='yadm shortlog -sn'
alias ycp='yadm cherry-pick'
alias ycpa='yadm cherry-pick --abort'
alias ycpc='yadm cherry-pick --continue'
alias ycs='yadm commit -S'

alias yd='yadm diff'
alias ydca='yadm diff --cached'
alias ydcw='yadm diff --cached --word-diff'
alias ydct='yadm describe --tags `yadm rev-list --tags --max-count=1`'
alias yds='yadm diff --staged'
alias ydt='yadm diff-tree --no-commit-id --name-only -r'
alias ydw='yadm diff --word-diff'

alias yf='yadm fetch'
alias yfa='yadm fetch --all --prune'
alias yfo='yadm fetch origin'

alias yg='yadm gui citool'
alias yga='yadm gui citool --amend'

alias ygpur='ygu'

alias yypull='yadm pull origin "$(yadm_current_branch)"'

alias yypush='yadm push origin "$(yadm_current_branch)"'

alias yysup='yadm branch --set-upstream-to=origin/$(yadm_current_branch)'
alias ypsup='yadm push --set-upstream origin $(yadm_current_branch)'

alias yhh='yadm help'

alias yignore='yadm update-index --assume-unchanged'
alias yignored='yadm ls-files -v | grep "^[[:lower:]]"'
alias yadm-svn-dcommit-push='yadm svn dcommit && yadm push yadmhub master:svntrunk'

alias yk='\yadmk --all --branches'
alias yke='\yadmk --all $(yadm log -g --pretty=%h)'

alias yl='yadm pull'
alias ylg='yadm log --stat'
alias ylgp='yadm log --stat -p'
alias ylgg='yadm log --graph'
alias ylgga='yadm log --graph --decorate --all'
alias ylgm='yadm log --graph --max-count=10'
alias ylo='yadm log --oneline --decorate'
alias ylol="yadm log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias ylols="yadm log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat"
alias ylod="yadm log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
alias ylods="yadm log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
alias ylola="yadm log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all"
alias ylog='yadm log --oneline --decorate --graph'
alias yloga='yadm log --oneline --decorate --graph --all'
alias ylp="_yadm_log_prettily"

alias ym='yadm merge'
alias ymom='yadm merge origin/master'
alias ymt='yadm mergetool --no-prompt'
alias ymtvim='yadm mergetool --no-prompt --tool=vimdiff'
alias ymum='yadm merge upstream/master'
alias yma='yadm merge --abort'

alias yp='yadm push'
alias ypd='yadm push --dry-run'
alias ypf='yadm push --force-with-lease'
alias ypf!='yadm push --force'
alias ypoat='yadm push origin --all && yadm push origin --tags'
alias ypu='yadm push upstream'
alias ypv='yadm push -v'

alias yr='yadm remote'
alias yra='yadm remote add'
alias yrb='yadm rebase'
alias yrba='yadm rebase --abort'
alias yrbc='yadm rebase --continue'
alias yrbd='yadm rebase develop'
alias yrbi='yadm rebase -i'
alias yrbm='yadm rebase master'
alias yrbs='yadm rebase --skip'
alias yrh='yadm reset'
alias yrhh='yadm reset --hard'
alias yrm='yadm rm'
alias yrmc='yadm rm --cached'
alias yrmf='yadm rm --cached -f'
alias yrmv='yadm remote rename'
alias yrrm='yadm remote remove'
alias yrset='yadm remote set-url'
alias yrt='cd $(yadm rev-parse --show-toplevel || echo ".")'
alias yru='yadm reset --'
alias yrup='yadm remote update'
alias yrv='yadm remote -v'

alias ysb='yadm status -sb'
alias ysd='yadm svn dcommit'
alias ysh='yadm show'
alias ysi='yadm submodule init'
alias ysps='yadm show --pretty=short --show-signature'
alias ysr='yadm svn rebase'
alias yss='yadm status -s'
alias yst='yadm status'
alias ysta='yadm stash save'
alias ystaa='yadm stash apply'
alias ystc='yadm stash clear'
alias ystd='yadm stash drop'
alias ystl='yadm stash list'
alias ystp='yadm stash pop'
alias ysts='yadm stash show --text'
alias ystall='yadm stash --all'
alias ysu='yadm submodule update'

alias yts='yadm tag -s'
alias ytv='yadm tag | sort -V'

alias yunignore='yadm update-index --no-assume-unchanged'
alias yunwip='yadm log -n 1 | grep -q -c "\-\-wip\-\-" && yadm reset HEAD~1'
alias yup='yadm pull --rebase'
alias yupv='yadm pull --rebase -v'
alias yupa='yadm pull --rebase --autostash'
alias yupav='yadm pull --rebase --autostash -v'
alias ylum='yadm pull upstream master'

alias ywch='yadm whatchanged -p --abbrev-commit --pretty=medium'
alias ywip='yadm add -A; yadm rm $(yadm ls-files --deleted) 2> /dev/null; yadm commit --no-verify -m "--wip-- [skip ci]"'
