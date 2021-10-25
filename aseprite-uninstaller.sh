#!/bin/sh

# Impedir que o usuário rode o script sendo root
if [ $(id -u) = 0 ];
then
  echo "Por favor, execute esse script sem usar sudo ou ser usuário root"
  exit 1
fi

echo -e "\e[1;33m

  ____ ___  _     __  __ _____ ___    _    
 / ___/ _ \| |   |  \/  | ____|_ _|  / \   
| |  | | | | |   | |\/| |  _|  | |  / _ \  
| |__| |_| | |___| |  | | |___ | | / ___ \ 
 \____\___/|_____|_|  |_|_____|___/_/   \_\ 
 
----------------------------------------------------
 
 Github : https://github.com/ColmeiaUDESC
 
----------------------------------------------------
 
 All rights reserved to: https://github.com/aseprite
 
----------------------------------------------------
"

DIR_INSTALACAO=$HOME/aseprite
ARGS=$(getopt -a -n aseprite-installer.sh -o f: --long dir-instalacao: -- "$@")
eval set -- "$ARGS"
while :
do
  case "$1" in
    --dir-instalacao) 
        DIR_INSTALACAO="$2"
        shift 2 ;;
    --) shift; break ;;
  esac
done

if ! [ -d $DIR_INSTALACAO ]
then
  echo "$DIR_INSTALACAO não existe. Abortando..."
  exit 1
fi

read -p "Você têm certeza que deseja desinstalar o aseprite localizado no diretório $DIR_INSTALACAO? (Y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo rm -r $DIR_INSTALACAO/aseprite
  sudo rm -r ~/deps
  sudo rm $HOME/.local/share/applications/aseprite.desktop
  sudo rm $HOME/.local/share/icons/hicolor/16x16/apps/aseprite.png
  sudo rm $HOME/.local/share/icons/hicolor/32x32/apps/aseprite.png
  sudo rm $HOME/.local/share/icons/hicolor/48x48/apps/aseprite.png
  sudo rm $HOME/.local/share/icons/hicolor/64x64/apps/aseprite.png
  sudo rm $HOME/.local/share/icons/hicolor/128x128/apps/aseprite.png
  sudo rm $HOME/.local/share/icons/hicolor/256x256/apps/aseprite.png
else
  echo "Abortando..."
fi
