if [[ ":$PATH:" != *:"/usr/local/bin":* ]]; then
  export PATH="/usr/local/bin:$PATH"
fi

GOOGLE_CLOUD_SDK_HOME=~/google-cloud-sdk
if [ -d $GOOGLE_CLOUD_SDK_HOME ]; then
  . $GOOGLE_CLOUD_SDK_HOME
fi

if [[ ":$PATH:" != *:"$HOME/bin":* ]]; then
  export PATH="$HOME/bin:$PATH"
fi

if [ -L ~/.rbenv ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

if [ -d ~/.nodebrew ]; then
  export NODEBREW_ROOT=$HOME/.nodebrew
  export PATH=$NODEBREW_ROOT/current/bin:$PATH
fi

XCODE_BIN=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
if [ -d $XCODE_BIN ]; then
  export PATH="$XCODE_BIN:$PATH"
fi

if [ -d $PYENV_ROOT ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

if [ -x "`which go`" ]; then
  export GOROOT=`go env GOROOT`
  export GOPATH=$HOME
  export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
fi

if [ -x "`which dirnenv`" ]; then
  eval "$(direnv hook zsh)"
fi
