
#!/bin/bash
# idea from @smockle (http://github.com/smockle/dotfiles)

set -e

platform=''
case "$OSTYPE" in
  solaris*) platform='solaris' ;;
  darwin*)  platform='osx' ;;
  linux*)   platform='linux' ;;
  bsd*)     platform='bsd' ;;
  *)        platform='windows' ;;
esac

cd ~

if [ -f '.bashrc']; then
  rm .bashrc
fi

ln -s Projects/dotfiles/.bashrc .bashrc

if [[ $platform == 'osx' ]]; then
  pushd ~/Library/Application\ Support/Code/User

  if [ -f 'settings.json' ]; then
    rm settings.json
  fi
  if [ -f 'keybindings.json' ]; then
    rm keybindings.json
  fi

  ln -s ~/Projects/dotfiles/vs-code/settings.json    ./settings.json
  ln -s ~/Projects/dotfiles/vs-code/keybindings.json ./keybindings.json
  popd
fi



