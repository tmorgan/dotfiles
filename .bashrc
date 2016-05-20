# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color)
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    ;;
*)
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    ;;
esac

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if which ghc >/dev/null
then
  function hmap { ghc -e "interact ($*)";  }
  function hmapl { hmap  "unlines.($*).lines" ; }
  function hmapw { hmapl "map (unwords.($*).words)" ; }
fi  

alias emacs='vim'
alias xemacs='gvim'
alias gvim='gvim --remote-tab-silent'

export PYTHONIOENCODING=utf-8
export PYTHONSTARTUP=$HOME/.pyrc

alias sbash="script -f -a ~/script.out bash"
alias serve="python2.7 -m SimpleHTTPServer 8080"
alias clear='use crtl-L'

# share history across terminals
export HISTSIZE=100000
export ignoredups
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Change the window title of X terminals
case ${TERM} in
        xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
           PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
        ;;
        screen)
           PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
           
           # make vim's backspace work in screen
           stty erase ^?
        ;;
esac

# Tab completion for ssh hosts, from:
#  http://feeds.macosxhints.com/~r/macosxhints/recent/~3/257065700/article.php
complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh 

# Send over your public key to a remote host.
apply_ssh() {
  ssh $1 "cat >> ~/.ssh/authorized_keys" < ~/.ssh/id_rsa.pub
}


# opening ssh to regular subdomains as $sshx subdomain
export SERVERTLD='tonymorgan.me'
sshx() {
    ssh ubuntu@$1.$SERVERTLD
}
# mounting home dir of server at ~/server_subdomain: $mountx subdomain
mountx() {
    pgrep -f sshfs.*$1.$SERVERTLD | xargs kill -9
    sudo umount ~/server_$1
    mkdir -p ~/server_$1
    sshfs ubuntu@$1.$SERVERTLD: ~/server_$1
}
# open up connections to each server in new tab
alias st="gnome-terminal --tab -e 'bash -i -c \"sshx a\"' --tab -e 'bash -i -c \"sshx b\"' --tab -e 'bash -i -c \"sshx c\"'"
alias tunnel="pgrep -f autossh | xargs kill -9  && autossh -f -M 20000 -D 8080 tonymorgan.me -N"

# PATH=/home/tony/usr_node/bin:/home/tony/usr_haskell/bin:$PATH

alias pypath="export PYTHONPATH=$PYTHONPATH:`pwd`"


PATH=/home/tony/.cabal/bin:$PATH
GOPATH=/home/tony/gocode
export GOPATH=$HOME/gopath
export PATH=$GOPATH:$GOPATH/bin:$PATH

eval "$(stack --bash-completion-script stack)"
export PATH=/home/tony/anaconda3/bin:$PATH
export ANDROID_HOME=/usr/local/android-sdk-linux
export PATH=$PATH:/usr/local/android-sdk-linux/bin
export PATH=$PATH:/usr/local/android-sdk-linux/tools/
export PATH=$PATH:/usr/local/android-studio/bin

alias lock="dbus-send --type=method_call --dest=org.gnome.ScreenSaver     /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock"
