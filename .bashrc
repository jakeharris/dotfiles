# Many snippets stolen (with love!) from @smockle (smockle/dotfiles).

##
## PLATFORM-INDEPENDENT
##

platform=''
case "$OSTYPE" in
  solaris*) platform='solaris' ;;
  darwin*)  platform='osx' ;;
  linux*)   platform='linux' ;;
  bsd*)     platform='bsd' ;;
  *)        platform='windows' ;;
esac

##
## OS X DEFAULTS
## (with slight adjustments for preference)
## note: may need to be in a platform==osx 
## block
## 

# System-wide .bashrc file for interactive bash(1) shells.
if [ -z "$PS1" ]; then
   return
fi

PS1='\u@\w \$ '
# Make bash check its window size after a process completes
shopt -s checkwinsize
# Tell the terminal about the working directory at each prompt.
if [ "$TERM_PROGRAM" == "Apple_Terminal" ] && [ -z "$INSIDE_EMACS" ]; then
    update_terminal_cwd() {
        # Identify the directory using a "file:" scheme URL,
        # including the host name to disambiguate local vs.
        # remote connections. Percent-escape spaces.
        local SEARCH=' '
        local REPLACE='%20'
        local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
        printf '\e]7;%s\a' "$PWD_URL"
    }
    PROMPT_COMMAND="update_terminal_cwd; $PROMPT_COMMAND"
fi

# Add ~/bin to $PATH
export PATH="$PATH:$HOME/bin"

# Make repeated commands not show up in history.
# Make commands preceeded by a space not show up in history.
export HISTCONTROL=ignoreboth

# Make specific commands not show up in history.
export HISTIGNORE="ls:cd:cd -:exit:* --help"

# Detect which ls flavor is in use.
if ls --color > /dev/null 2>&1; then # GNU ls
  colorflag="--color"
else # OS X ls
  colorflag="-G"
fi

# Always use color output for ls.
alias ls="command ls ${colorflag}"
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

if [[ $platform == 'windows' ]]; then
    # Add hub alias
    alias git='hub'
else
    # Add hub alias
    eval "$(hub alias -s)"
fi

# Use git diff instead of diff.
alias diff='git diff'

##
## WINDOWS-SPECIFIC
##


if [[ $platform == 'windows' ]]; then
  command cd ~

  # Add hub to $PATH
  export PATH="/c/Program Files/hub:$PATH"

  # ifconfig does not exist in Git Bash (Windows).
  alias ifconfig='ipconfig'

  # more does not exist in Git Bash (Windows).
  alias more='less'

  # open does not exist in Git Bash (Windows).
  alias open='start'
fi


##
## OSX-SPECIFIC
##


if [[ $platform == 'osx' ]]; then
  # Add $(brew --prefix)/bin to $PATH.
  export PATH="$(brew --prefix)/bin:$PATH"

  # Enable brew's bash completion
  if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    . "$(brew --prefix)/etc/bash_completion"
  fi

  # Set $ATOM_PATH
  if [[ -d "$HOME/Applications/Atom.app" ]]; then
    export ATOM_PATH="$HOME/Applications"
  elif [[ -d "/Applications/Atom.app" ]]; then
    export ATOM_PATH="/Applications"
  fi

  # Empty the Trash on all mounted volumes and the main HDD.
  # Clear Apple’s System Logs to improve shell startup speed.
  trash() {
    sudo rm -rfv /Volumes/*/.Trashes
    sudo rm -rfv ~/.Trash
    sudo rm -rfv /private/var/log/asl/*.asl
  }
fi

##
## NON-WINDOWS
##


if [[ $platform != 'windows' ]]; then
  # Always enable colored grep output.
  export GREP_OPTIONS="--color=auto"

  # Add travis to $PATH.
  [ -f /Users/clay/.travis/travis.sh ] && source /Users/clay/.travis/travis.sh

  # Update hosts file.
  _update_hosts() {
    wget -N -P ~/Projects/dotfiles http://someonewhocares.org/hosts/hosts
    sudo cp -f ~/Projects/dotfiles/hosts /etc/hosts
    dscacheutil -flushcache
  }

  # Set wget download location.
  alias wget='wget -P ~/Downloads'

  # Add tab completion for sudo.
  complete -cf sudo
fi

##
## CROSS-PLATFORM
##

# Start fasd.
eval "$(fasd --init auto)"
_ahriman_cd() {
  if [[ -d $1 ]]; then
    command cd "$1"
  elif [[ -f $1 ]]; then
    command cd "$(dirname "$1")"
  else
    fasd_cd -d "$1"
  fi
}
alias cd='_ahriman_cd'

# Update system.
update() {
  if [[ $platform != 'windows' ]]; then
    _update_hosts
  fi
}
