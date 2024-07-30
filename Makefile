DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
OS := $(shell bin/is-supported bin/is-macos macos linux)
HOMEBREW_PREFIX := $(shell bin/is-supported bin/is-macos $(shell bin/is-supported bin/is-arm64 /opt/homebrew /usr/local) /home/linuxbrew/.linuxbrew)
export N_PREFIX = $(HOME)/.n
PATH := $(HOMEBREW_PREFIX)/bin:$(DOTFILES_DIR)/bin:$(N_PREFIX)/bin:$(PATH)
#SHELL := env PATH=$(PATH) /bin/bash
SHELL := /bin/zsh
SHELLS := /private/etc/shells
BIN := $(HOMEBREW_PREFIX)/bin
BREW_OPTS := --verbose
export XDG_CONFIG_HOME = $(HOME)/.config
export STOW_DIR = $(DOTFILES_DIR)
export ACCEPT_EULA=Y

.PHONY: test

all: $(OS)

macos: sudo core-macos packages core-node link duti vscode-extensions misc

linux: core-linux link

# core-macos: brew bash git npm
core-macos: brew git npm

core-linux:
	apt-get update
	apt-get upgrade -y
	apt-get dist-upgrade -f

stow-macos: brew
	is-executable stow || brew install stow

stow-linux: core-linux
	is-executable stow || apt-get -y install stow

sudo:
ifndef GITHUB_ACTION
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
endif

packages: brew-packages cask-apps

core-node: npm node-packages

link: stow-$(OS)
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	mkdir -p $(XDG_CONFIG_HOME)
	stow -t $(HOME) runcom
	stow -t $(XDG_CONFIG_HOME) config
	mkdir -p $(HOME)/.local/runtime
	chmod 700 $(HOME)/.local/runtime

unlink: stow-$(OS)
	stow --delete -t $(HOME) runcom
	stow --delete -t $(XDG_CONFIG_HOME) config
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

bash: brew
ifdef GITHUB_ACTION
	if ! grep -q bash $(SHELLS); then \
		brew install bash bash-completion@2 pcre && \
		sudo append bash $(SHELLS) && \
		sudo chsh -s bash; \
	fi
else
	if ! grep -q bash $(SHELLS); then \
		brew install bash bash-completion@2 pcre && \
		sudo append bash $(SHELLS) && \
		chsh -s bash; \
	fi
endif

git: brew
	brew install git git-extras $(BREW_OPTS)

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile $(BREW_OPTS) || true

cask-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile $(BREW_OPTS) || true
	defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

npm: brew-packages
	n install lts

node-packages: npm
	$(N_PREFIX)/bin/npm install --force --location global $(shell cat install/npmfile)

duti:
	duti -v $(DOTFILES_DIR)/install/duti

vscode-extensions: cask-apps
	for EXT in $$(cat install/Codefile); do code --install-extension $$EXT; done

# Install fzf
fzf:
	eval "$(/opt/homebrew/bin/brew shellenv)"
	$(brew --prefix)/opt/fzf/install

# Install oh-my-zsh
oh-my-zsh:
	sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install just spring
oh-my-zsh:
	sh -c "$(curl -Lo just.zip https://github.com/maciejwalkowiak/just/releases/latest/download/just-0.14.0-osx-x86_64.zip && unzip just.zip && rm just.zip && chmod +x just && sudo mv just /usr/local/bin/spring-just)"


jenv:
	#jenv add /Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home
	#jenv add /Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home
	#jenv add /Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Home
	#jenv add /Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home
	#jenv add /Library/Java/JavaVirtualMachines/temurin-22.jdk/Contents/Home/

python:
	pip3.12 install -r ./install/Pythonfile --break-system-packages

misc: oh-my-zsh fzf jenv python

cleanup:
	brew cleanup $(BREW_OPTS)

test:
	bats test
