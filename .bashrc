# Define utility function
pathadd() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":1"* ]]; then
	  PATH="$1${PATH:+":$PATH"}"
  fi
}

# Preload some of the most commonly used modules
module load 'R/4.0.2'
module load 'tmux/3.3a'
module load 'cmake/3.22.1'

# Set some useful aliases
alias ll='ls -lah'
alias usqueue='squeue --user=${USER}'
alias cdwork='cd /work/ec232/ec232/${USER}'
alias update-hpc-setup='(cd $HOME/hpc-setup && git pull)'

# Create user-specific bin folder and update path
[[ -d $HOME/.local/share/bin ]] || mkdir -p "$HOME/.local/share/bin"
[[ -d $HOME/.local/bin ]] || mkdir -p "$HOME/.local/bin"

pathadd "$HOME/.local/share/bin"
pathadd "$HOME/.local/bin"

unset pathadd
export PATH

# Some convenience features
# Make a Downloads directory (if it does not exist) and cd into it
mkdir -p "$HOME/Downloads"

# Download and install GitHub CLI
if ! [[ -f "$HOME/.local/bin/gh" ]]; then
	echo 'Installing GitHub CLI'
	cd "$HOME/Downloads" || exit
	wget -q "https://github.com/cli/cli/releases/download/v2.21.2/gh_2.21.2_linux_amd64.tar.gz"
	tar xf "gh_2.21.2_linux_amd64.tar.gz" --strip-components=1 --directory="$HOME/.local"
	[[ -f $HOME/.local/bin/gh ]] || echo 'Something went wrong with GitHub CLI install'
fi;

# Download and install Micro
if ! [[ -f "$HOME/.local/bin/micro" ]]; then
	cd "$HOME/.local/bin" || exit;
	curl 'https://getmic.ro' | bash - ;
	cd "$HOME" || exit
fi;

# Return home
cd "${HOME}" || exit
export EDITOR="$HOME/.local/bin/micro"

# Uncomment these two lines if you want to see the full current working directory visible at all times on the prompt
#PS1="[\u \$PWD]$ "
#export PS1