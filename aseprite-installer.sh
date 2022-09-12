#!/bin/bash

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

# Processar argumentos para conseguir o diretorio padrao
DIR_INSTALACAO=$HOME
ARGS=$(getopt -a -n aseprite-installer.sh -o f: --long dir-instalacao: -- "$@")
eval set -- "$ARGS"
while :
do
  case "$1" in
    -f | --dir-instalacao)
      if [ -f $2 ]; then
        echo "$2 é um arquivo. Abortando."
        exit 1
      fi
      mkdir -p $2
      DIR_INSTALACAO=$2
      shift 2
      ;;
    --) 
      shift
      break
      ;;
  esac
done

# Checar a arquitetura e sistema operacional na qual estamos rodando
OS_ARCH="$(uname -m)"
[ $OS_ARCH = "x86_64" ] && OS_ARCH="x64"
command -v apt-get > /dev/null && OS_DISTRO="debian"
command -v pacman > /dev/null && OS_DISTRO="arch"
command -v dnf > /dev/null && OS_DISTRO="fedora"
[ -z ${OS_DISTRO+x} ] && { echo "Sistema operacional não suportado. Abortando.."; exit 1; }

# Instalar dependencias
[ $OS_DISTRO = "debian" ] && sudo apt-get install -y g++ clang-11 libc++-11-dev libc++abi-11-dev cmake ninja-build libx11-dev libxcursor-dev libxi-dev libgl1-mesa-dev libfontconfig1-dev && export CC=/usr/bin/clang-11 && export CXX=/usr/bin/clang++-11
[ $OS_DISTRO = "arch" ] && sudo pacman -S --needed gcc cmake gcc clang libc++ cmake ninja libx11 libxcursor mesa-libgl fontconfig unzip && export CC=/usr/bin/clang && export CXX=/usr/bin/clang++
[ $OS_DISTRO = "fedora" ] && sudo dnf install -y gcc-c++ clang libcxx-devel cmake ninja-build libX11-devel libXcursor-devel libXi-devel mesa-libGL-devel fontconfig-devel && export CC=/usr/bin/clang && export CXX=/usr/bin/clang++

# Baixar os arquivos
cd ~/Downloads
SKIA_ZIP="Skia-Linux-Release-$OS_ARCH-libc++.zip"
SKIA_RELEASE="Release-$OS_ARCH"
VERSION="1.2.40"
ASEPRITE_ZIP="Aseprite-v$VERSION-Source.zip"
wget https://github.com/aseprite/skia/releases/download/m102-861e4743af/$SKIA_ZIP; mkdir -p ~/deps/skia; sudo unzip $SKIA_ZIP -d ~/deps/skia
wget https://github.com/aseprite/aseprite/releases/download/v$VERSION/$ASEPRITE_ZIP; mkdir -p $DIR_INSTALACAO/aseprite/build; sudo unzip $ASEPRITE_ZIP -d $DIR_INSTALACAO/aseprite;

# Compilar o aseprite
cd $DIR_INSTALACAO/aseprite/build

cmake \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_CXX_FLAGS:STRING=-stdlib=libc++ \
  -DCMAKE_EXE_LINKER_FLAGS:STRING=-stdlib=libc++ \
  -DLAF_BACKEND=skia \
  -DSKIA_DIR=$HOME/deps/skia \
  -DSKIA_LIBRARY_DIR=$HOME/deps/skia/out/$SKIA_RELEASE \
  -DSKIA_LIBRARY=$HOME/deps/skia/out/$SKIA_RELEASE/libskia.a \
  -G Ninja \
  ..
ninja aseprite

# Limpar pasta downloads
cd ~/Downloads
rm $ASEPRITE_ZIP
rm $SKIA_ZIP

# Criar icone
DIR_SHARE=$HOME/.local/share
DIR_ICONES=$DIR_SHARE/icons/hicolor
ASEPRITE_DESKTOP=$DIR_SHARE/applications/aseprite.desktop
cd $DIR_INSTALACAO/aseprite/build/bin/data/icons
mkdir -p $DIR_ICONES/16x16/apps && cp ase16.png $_/aseprite.png 
mkdir -p $DIR_ICONES/32x32/apps && cp ase32.png $_/aseprite.png
mkdir -p $DIR_ICONES/48x48/apps && cp ase48.png $_/aseprite.png
mkdir -p $DIR_ICONES/64x64/apps && cp ase64.png $_/aseprite.png
mkdir -p $DIR_ICONES/128x128/apps && cp ase128.png $_/aseprite.png
mkdir -p $DIR_ICONES/256x256/apps && cp ase256.png $_/aseprite.png
echo "[Desktop Entry]" > $ASEPRITE_DESKTOP
echo "Type=Application" >> $ASEPRITE_DESKTOP
echo "Name=Aseprite" >> $ASEPRITE_DESKTOP
echo "Exec=sh -c \"$DIR_INSTALACAO/aseprite/build/bin/aseprite\" " >> $ASEPRITE_DESKTOP
echo "Icon=aseprite" >> $ASEPRITE_DESKTOP
echo "Terminal=false" >> $ASEPRITE_DESKTOP
echo "Categories=Graphics;2DGraphics;" >> $ASEPRITE_DESKTOP

echo "Finalizado"