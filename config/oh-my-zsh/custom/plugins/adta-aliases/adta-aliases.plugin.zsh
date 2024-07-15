# Started from Nacho common-aliases plugin
# and then simplified and modified to my needs.
# Unused alias are commented out.

# Base Aliases
# Shortcuts
alias reload="source ~/.zshrc"
# List declared aliases, functions, paths
alias aliases="alias | sed 's/=.*//'"
alias paths='echo -e ${PATH//:/\\n}'
# Network
alias ip="curl -s ipinfo.io | jq -r '.ip'"
alias ipl="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
# Miscellaneous
alias hosts="sudo $EDITOR /etc/hosts"
alias quit="exit"
alias week="date +%V"
alias speedtest="wget -O /dev/null http://speed.transip.nl/100mb.bin"
alias grip="grip --browser --pass=$GITHUB_TOKEN"

# Core Aliases.
#
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias help='man'
alias hgrep="fc -El 0 | grep" # search your command history for a specific string using grep
alias ps='ps -f'
#alias h='history'
#alias sortnr='sort -n -r'
#alias unexport='unset'

# ---------------- #
# Development zone #
# ---------------- #

# Misc
# -
alias quick-clean="find . -name target -exec rm -rf {} \;" # find and delete all directories named target starting from the current directory.

# Java
# -
alias j21="jenv local 21; export JAVA_HOME=`/usr/libexec/java_home -v 21`; java -version"
# alias j20="export JAVA_HOME=`/usr/libexec/java_home -v 20`; java -version"
# alias j19="export JAVA_HOME=`/usr/libexec/java_home -v 19`; java -version"
# alias j18="export JAVA_HOME=`/usr/libexec/java_home -v 18`; java -version"
alias j17="jenv local 17; export JAVA_HOME=`/usr/libexec/java_home -v 17`; java -version"
# alias j16="export JAVA_HOME=`/usr/libexec/java_home -v 16`; java -version"
# alias j15="export JAVA_HOME=`/usr/libexec/java_home -v 15`; java -version"
# alias j14="export JAVA_HOME=`/usr/libexec/java_home -v 14`; java -version"
# alias j13="export JAVA_HOME=`/usr/libexec/java_home -v 13`; java -version"
# alias j12="export JAVA_HOME=`/usr/libexec/java_home -v 12`; java -version"
alias j11="jenv local 11; export JAVA_HOME=`/usr/libexec/java_home -v 11`; java -version"
# alias j10="export JAVA_HOME=`/usr/libexec/java_home -v 10`; java -version"
# alias j9="export JAVA_HOME=`/usr/libexec/java_home -v 9`; java -version"
alias j8="jenv local 1.8; export JAVA_HOME=`/usr/libexec/java_home -v 1.8`; java -version"
# alias j7="export JAVA_HOME=`/usr/libexec/java_home -v 1.7`; java -version"

# Grep aliases and functions
# -
alias grep='grep --color'
jgrep() {
  grep -r --color=auto --include="*.java" $1
}
sgrep() {
  grep -r --color=auto --include="*.scala" $1
}
ggrep() {
  grep -r --color=auto --include="*.graphql" $1
}
ygrep() {
  grep -r --color=auto --include="*.yaml" $1
}
xgrep() {
  grep -r --color=auto --include="*.xml" $1
}
alias devgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS,target,.idea} '

# file editing
alias -s java='idea'  # open java file with idea
alias -s scala='idea' # open scala file with idea

# Git
# -
# Revert last commit and keep changes locally
alias grlast=git reset --soft HEAD~1

# Go to master/main, update and create a new branch $1
gmnb() { gcm; gl; gco -b $1; }
# Fetch origin changes and merge then into current branch
gmo() {
  git fetch origin $1
  git merge origin/$1
}
# List files more frequently modified (commits)
gsfm() {
  git log --pretty=format: --name-only | sort | uniq -c | sort -rg | head -10
}
# List authors sorted by commit
gsac1() {
  git ls-files | while read f; do git blame --line-porcelain $f | grep '^author '; done | sort -f | uniq -ic | sort -n
}
gsac2() {
  git shortlog -sn --all
}
# Get commit count for specific folder
gscc() {
  git log --name-only --pretty=format: -- $1 | sort | uniq -c | head -n 1
}
# Git squash and commit vs current status of master. Commit message required as parameter
gsq() {
  CURRENT=`git rev-parse --abbrev-ref HEAD`;
  git reset $(git merge-base master $CURRENT)
  git add -A
  git commit -m $1
}
# Git squash and commit vs current status of a given branch. Commit message required as parameter
gsq2() {
  CURRENT=`git rev-parse --abbrev-ref HEAD`;
  git reset $(git merge-base $1 $CURRENT)
  git add -A
  git commit -m $2
}

# --------------------------#
# Docker alias and function #
# ------------------------- #

# Get latest container ID
alias dl="docker ps -l -q"
# List running containers (formatted)
alias dkps="docker ps --format '{{.ID}} ~ {{.Names}} ~ {{.Status}} ~ {{.Image}}'"
# List running containers (formatted)
alias dkpa="docker ps -a --format '{{.ID}} ~ {{.Names}} ~ {{.Status}} ~ {{.Image}}'"
# List containers stats (formatted)
dktop() {
  docker stats --format "table {{.Container}}\t{{.Name}}\t{{.CPUPerc}}  {{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}"
}
# Get images
alias dki="docker images"
# Run interactive container, e.g., $dki base /bin/bash
alias dki="docker run -i -t -P"
# Execute interactive container, e.g., $dex base /bin/bash
alias dkex="docker exec -i -t"
# Stop all containers
dstop() { docker stop $(docker ps -a -q); }
# Remove all containers
drma() { docker rm $(docker ps -a -q); }
# Stop and Remove all containers
alias drmf='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'
# Remove dangling images
dkrmdi() { docker rmi $(docker images --filter "dangling=true" -q --no-trunc) || true; }
# Remove all images
dkri() { docker rmi $(docker images -q); }
# Bash into running container
dkbash() { docker exec -it $(docker ps -aqf "name=$1") bash; }

# Get container IP
alias dkip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
# Run deamonized container, e.g., $dkd base /bin/echo hello
alias dkd="docker run -d -P"
# Show all alias related docker
dkalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }
# Dockerfile build, e.g., $dbu tcnksm/test
dkbu() { docker build -t=$1 .; }

# ls, the common ones I use a lot shortened for rapid fire usage
alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
#alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='ls -l'      #long list
alias ldot='ls -ld .*'
#alias lS='ls -1FSsh'
#alias lart='ls -1Fcart'
#alias lrt='ls -1Fcrt'
#alias lsr='ls -lARFh' #Recursive list of files and directories
#alias lsn='ls -1'     #A column contains name of files and directories


# Command line head / tail shortcuts
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g F="| fzf"
#alias -g L="| less"
#alias -g M="| most"
#alias -g LL="2>&1 | less"
#alias -g CA="2>&1 | cat -A"
#alias -g NE="2> /dev/null"
#alias -g NUL="> /dev/null 2>&1"
#alias -g P="2>&1| pygmentize -l pytb"

### Command line searching
alias ff='find . -type f -name'
(( $+commands[fd] )) || alias fd='find . -type d -name'

### Disk usage
alias dud='du -d 1 -h'
(( $+commands[duf] )) || alias duf='du -sh *'

### JUSTFILE (From Nacho, customize later)
alias jl='just --list'
alias js='just --show'
alias jd='just --dump'
alias jv='just --evaluate'
alias je='idea justfile'
alias j='just '
#alias jc='just --choose'
## better choose that print the choosen command before running
jc() {
  local choosen
  choosen=$(just --list | fzf --preview='just --show {1}' --height 40% --reverse --border --prompt="choose: " | awk '{print $1}')
  if [ -n "$choosen" ]; then
    echo "just $choosen"
    just "$choosen"
  fi
}

### taskwarrior (From Nacho, customize later)
# context: study, work, home
#
alias tw='task '
alias twl='task list '
alias twx='task done '
alias twa='task add '
alias tws='task start '
alias twss='task stop '
alias twe='task edit '
alias twp='task project '
alias twt='task tag '
alias twd='task delete '
alias twc='task context '
alias twr='task report '
alias twsm='task summary '
alias twaa='task annotate '
alias twu='usage_taskwarrior_aliases'

# active each context
alias twcs='task context show'
alias twcs='task context study'
alias twch='task context home'
alias twcw='task context work'
alias twcn='task context none' # deactive

# taskwarrior select a task to start
twsel() {
  local task
  task=$(task list | fzf --height 40% --reverse --border --prompt="select task: " | awk '{print $1}')
  if [ -n "$task" ]; then
    echo "task start $task"
    task start "$task"
  fi
}

function usage_taskwarrior_aliases() {
  cat <<EOF
  tw - task
  twaa - task annotate
  twl - list tasks
  twx - done task
  twa - add task
  tws - start task
  twss - stop task
  twe - edit task
  twp - project task
  twt - tag task
  twd - delete task
  twc - context task
  twr - report task
  twsm - summary task

  twcs - context study
  twch - context home
  twcw - context work
  twcn - context none
  twcd - context show

  twsel - select a task to start
EOF
}

# find an alias with fzf, and execute
af() {
  local alias
  # alias output is
#twcs='task context study'
#twcw='task context work'
#twch='task context home'
#twcn='task context none'
#twcd='task context show'
  alias=$(alias | fzf --height 40% --reverse --border --prompt="alias: " | awk -F"=" '{print $1}')
  if [ -n "$alias" ]; then
    echo "executing alias: $alias"
    eval "$alias"
  fi
}

# Other aliases ...

#alias zshrc='${=EDITOR} ${ZDOTDIR:-$HOME}/.zshrc' # Quick access to the .zshrc file
#alias t='tail -f' better use tmux or task
#alias h='history'
#alias hgrep="fc -El 0 | grep"
#alias help='man'
#alias p='ps -f'
#alias sortnr='sort -n -r'
#alias unexport='unset'

# zsh is able to auto-do some kungfoo
# depends on the SUFFIX :)
#autoload -Uz is-at-least
#if is-at-least 4.2.0; then
#  # open browser on urls
#  if [[ -n "$BROWSER" ]]; then
#    _browser_fts=(htm html de org net com at cx nl se dk)
#    for ft in $_browser_fts; do alias -s $ft='$BROWSER'; done
#  fi
#
#  _editor_fts=(cpp cxx cc c hh h inl asc txt TXT tex)
#  for ft in $_editor_fts; do alias -s $ft='$EDITOR'; done
#
#  if [[ -n "$XIVIEWER" ]]; then
#    _image_fts=(jpg jpeg png gif mng tiff tif xpm)
#    for ft in $_image_fts; do alias -s $ft='$XIVIEWER'; done
#  fi
#
#  _media_fts=(ape avi flv m4a mkv mov mp3 mpeg mpg ogg ogm rm wav webm)
#  for ft in $_media_fts; do alias -s $ft=mplayer; done
#
#  #read documents
#  alias -s pdf=acroread
#  alias -s ps=gv
#  alias -s dvi=xdvi
#  alias -s chm=xchm
#  alias -s djvu=djview
#
#  #list whats inside packed file
#  alias -s zip="unzip -l"
#  alias -s rar="unrar l"
#  alias -s tar="tar tf"
#  alias -s tar.gz="echo "
#  alias -s ace="unace l"
#fi

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'






### tmux: from Nacho, TO DEEP DIVE!
alias tx='tmux'
alias tl='tmux list-sessions' # list tmux sessions
#alias tk='tmux kill-session -t' # kill tmux session with name
alias td='tmux detach' # detach from tmux session

### tmux kill session and fzf for session name
tk() {
  local session
  session=$(tmux list-sessions | fzf --height 40% --reverse --border --prompt="kill session: " | awk '{print $1}')
  if [ -n "$session" ]; then
    tmux kill-session -t "$session"
  fi
}
### tmux attach to session and fzf for session
tat() {
  local session
  session=$(tmux list-sessions | fzf --height 40% --reverse --border --prompt="attach session: " | awk '{print $1}')
  if [ -n "$session" ]; then
    tmux attach -t "$session"
  fi
}

function usage_tmux_aliases() {
  cat <<EOF
  t - tmux
  tl - list tmux sessions
  tk - kill tmux session with fzf
  td - detach from tmux session
  tat - attach to tmux session with fzf
EOF
}

# Chores automation
# -
update_xcode() {
  # https://stackoverflow.com/questions/34617452/how-to-update-xcode-from-command-line
  sudo rm -rf /Library/Developer/CommandLineTools
  xcode-select --install
}

