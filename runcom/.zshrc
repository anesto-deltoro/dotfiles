# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export XDG_CONFIG_HOME="$HOME/.config" 
source ${XDG_CONFIG_HOME}/oh-my-zsh/.env

export ZSH_CUSTOM=${XDG_CONFIG_HOME}/oh-my-zsh/custom
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="crunch"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 30

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
#   git
  alias-finder
	docker
  docker-compose
 	jenv
  history
	macos
	git-prompt
  colored-man-pages
  brew
	tmux
	tmuxinator
  kubectl
	kube-ps1
)

custom_plugins=(
    ktools
    adta-aliases
    adta-aliases-macos
    functions
    kafka
    databases
    mrge
)
for p in "${custom_plugins[@]}"
do
    source "$ZSH_CUSTOM/plugins/$p/$p.plugin.zsh"
done

source $ZSH/oh-my-zsh.sh


# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="idea ~/.zshrc"
alias dotfile="idea ~/.dotfiles"

#### jenv Setup
# export PATH="$HOME/.jenv/shims:${PATH}"
# export JENV_SHELL=zsh
# export JENV_LOADED=1
# unset JAVA_HOME
# unset JDK_HOME

eval "$(jenv init -)"
# jenv enable-plugin export

#### Setup fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# To remove duplicate items in fzf prompt
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP

# Enable auto-completion for the AWS CLI commands
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

### kubernetes (kube_ps1)
# source "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"
PS1='$(kube_ps1)'$PS1
#PS1='['$'\U2615''$(jenv_prompt_info)]$(kube_ps1)'$PS1
# PROMPT='$(kube_ps1)'$PROMPT
# RPROMPT='$(jenv_prompt_info)'
RPROMPT='['$'\U2615''$(jenv_prompt_info)]'


# with alias-finder plugin
zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
zstyle ':omz:plugins:alias-finder' exact yes # disabled by default
zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default

#### Setup thefuck
eval $(thefuck --alias)
source /opt/homebrew/etc/profile.d/z.sh
# enable auto-completion for the AWS CLI commands
#complete -C /opt/homebrew/bin/aws_completer aws

# Raise limit for open files and processes
ulimit -S -n 8192
