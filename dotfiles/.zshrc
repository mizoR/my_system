# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="eastwood"

plugins=(git)

DISABLE_AUTO_UPDATE="true"

source $ZSH/oh-my-zsh.sh

if [ -L ~/.zsh-completions ]; then
  fpath=(~/.zsh-completions/src $fpath)
  autoload -U compinit; compinit -u
fi

for file in ~/.{aliases,functions}; do
  [ -r "$file" ] && source "$file"
done

chpwd() {
  ls
}

# '^' を押すと上のディレクトリに移動する
function cdup() {
  if [ -z "$BUFFER" ]; then
    echo
    cd ..
    zle reset-prompt
  else
    zle self-insert '^'
  fi
}

zle -N cdup
bindkey '\^' cdup

export BUNDLER_EDITOR=~/dotfiles/bin/bundler.sh

# https://github.com/lestrrat/peco
if [ -x "`which peco`" ]; then
  function peco-select-history() {
    local tac
    if which tac > /dev/null; then
      tac="tac"
    else
      tac="tail -r"
    fi
    BUFFER=$(fc -l -n 1 | \
      uniq | \
      eval $tac | \
      peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
  }
  zle -N peco-select-history
  bindkey '^r' peco-select-history

  # http://weblog.bulknews.net/post/89635306479/ghq-peco-percol
  function peco-src () {
    local selected_dir=$(ghq list --full-path | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
      BUFFER="cd ${selected_dir}"
      zle accept-line
    fi
    zle clear-screen
  }
  zle -N peco-src
  bindkey '^]' peco-src


  function peco-git-recent-branches () {
    local selected_branch=$(git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads | \
        perl -pne 's{^refs/heads/}{}' | \
        peco --query "$LBUFFER")
    if [ -n "$selected_branch" ]; then
      BUFFER="git checkout ${selected_branch}"
      zle accept-line
    fi
  }
  zle -N peco-git-recent-branches
  bindkey '^b' peco-git-recent-branches

  function peco-dropbox () {
    local dir=$(find ~/Dropbox/*/* -d | peco --query "$LBUFFER")
    if [ -n "$dir" ]; then
      BUFFER="cd ${dir}"
      zle accept-line
    fi
  }
  zle -N peco-dropbox
  bindkey '^[' peco-dropbox
fi
