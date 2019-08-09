
#!/bin/bash
# idea from @smockle
# techniques learned from @bryanbates

set -e

platform=''
case "$OSTYPE" in
  solaris*) platform='solaris' ;;
  darwin*)  platform='osx' ;;
  linux*)   platform='linux' ;;
  bsd*)     platform='bsd' ;;
  *)        platform='windows' ;;
esac

REPOROOT="$( cd $(dirname $0) ; pwd -P)"

if [ -f '.bashrc']; then
  rm .bashrc
fi

ln -s ${REPOROOT}/.bashrc .bashrc

if [[ $platform == 'osx' ]]; then
  pushd ~/Library/Application\ Support/Code/User

  if [ -f 'settings.json' ]; then
    rm settings.json
  fi
  if [ -f 'keybindings.json' ]; then
    rm keybindings.json
  fi

  ln -s ${REPOROOT}/vs-code/settings.json    ./settings.json
  ln -s ${REPOROOT}/vs-code/keybindings.json ./keybindings.json
  popd
fi



