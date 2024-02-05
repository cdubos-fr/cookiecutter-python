eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(
	gitfast
	pip
	python
	screen
	ubuntu
	docker
	docker-compose
	virtualenvwrapper
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

export PATH=$PATH:$HOME/.local/bin

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin
fpath=(~/.zsh/completion $fpath)
