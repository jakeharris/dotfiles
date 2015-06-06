
# idea from @smockle (http://github.com/smockle/dotfiles)
#!/bin/bash

platform=''
case "$OSTYPE" in
  solaris*) platform='solaris' ;;
  darwin*)  platform='osx' ;;
  linux*)   platform='linux' ;;
  bsd*)     platform='bsd' ;;
  *)        platform='windows' ;;
esac

ln -s ~/Projects/dotfiles/.bash_profile ~/.bash_profile

rm ~/.bashrc
ln -s ~/Projects/dotfiles/.bashrc ~/.bashrc

rm ~/.gitconfig
ln -s ~/Projects/dotfiles/.gitconfig ~/.gitconfig
if [[ $platform == 'windows' ]]; then
  git config --global credential.helper "!'C:\\Users\\unknownhybrid\\AppData\\Roaming\\GitCredStore\\git-credential-winstore.exe'"
fi
