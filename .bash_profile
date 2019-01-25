if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
  . `brew --prefix`/etc/bash_completion.d/git-completion.bash
fi

export FZF_DEFAULT_OPTS="--cycle"
export FZF_DEFAULT_COMMAND='
  (rg --files || git ls-tree -r --name-only HEAD ||
   find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
      sed s/^..//) 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='
  (git ls-tree -d -r --name-only HEAD ||
   find -L . \( -path "*/\.*" -o -fstype dev -o -fstype proc \) -prune -o -type d -print |
      sed 1d | cut -b3-) 2> /dev/null'

export GOPATH=$GOPATH:$HOME/go-code
export PATH=$PATH:$GOPATH/bin
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

source ~/go-code/tooling/buck-completion/buck-completion.bash
source ~/.fzf.bash
[ -r /Users/minho.park/.profile_lda ] && . /Users/minho.park/.profile_lda
