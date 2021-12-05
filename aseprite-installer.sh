#!/bin/sh

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

# Checar a arquitetura e sistema operacional na qual estamos rodando
OS_ARCH="$(uname -m)"
command -v apt-get > /dev/null && OS_DISTRO="debian"
command -v pacman > /dev/null && OS_DISTRO="arch"
command -v dnf > /dev/null && OS_DISTRO="fedora"
[ -z ${OS_DISTRO+x} ] && { echo "Sistema operacional não suportado. Abortando.."; exit 1; }

# Instalar dependencias
[ $OS_DISTRO = "debian" ] && sudo apt-get install -y g++ cmake ninja-build libx11-dev libxcursor-dev libxi-dev libgl1-mesa-dev libfontconfig1-dev
[ $OS_DISTRO = "arch" ] && sudo pacman -S --needed gcc cmake ninja libx11 libxcursor mesa-libgl fontconfig unzip
[ $OS_DISTRO = "dnf" ] && sudo dnf install -y gcc-c++ cmake ninja-build libX11-devel libXcursor-devel libXi-devel mesa-libGL-devel fontconfig-devel

# Baixar os arquivos
cd ~/Downloads
[ $OS_ARCH = "x86" ] && { SKIA_ZIP="Skia-Linux-Release-x86.zip"; SKIA_RELEASE="Release-x86"; } 
[ $OS_ARCH = "x86_64" ] && { SKIA_ZIP="Skia-Linux-Release-x64.zip";  SKIA_RELEASE="Release-x64"; }
wget https://github.com/aseprite/skia/releases/download/m81-b607b32047/$SKIA_ZIP; mkdir -p ~/deps/skia; sudo unzip $SKIA_ZIP -d ~/deps/skia
wget https://github.com/aseprite/aseprite/releases/download/v1.2.27/Aseprite-v1.2.27-Source.zip; mkdir -p ~/aseprite/build; sudo unzip Aseprite-v1.2.27-Source.zip -d ~/aseprite;

# Compilar o aseprite
cd ~/aseprite/build
cmake \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DLAF_BACKEND=skia \
  -DSKIA_DIR=$HOME/deps/skia \
  -DSKIA_LIBRARY_DIR=$HOME/deps/skia/out/$SKIA_RELEASE \
  -DSKIA_LIBRARY=$HOME/deps/skia/out/$SKIA_RELEASE/libskia.a \
  -G Ninja \
  ..
ninja aseprite

# Limpar pasta downloads
cd ~/Downloads
rm Aseprite-v1.2.27-Source.zip
rm $SKIA_ZIP

# Criar icone
DIR_SHARE=$HOME/.local/share
DIR_ICONES=$DIR_SHARE/icons/hicolor
ASEPRITE_DESKTOP=$DIR_SHARE/applications/aseprite.desktop
cd $HOME/aseprite/build/bin/data/icons
cp ase16.png $DIR_ICONES/16x16/apps/aseprite.png
cp ase32.png $DIR_ICONES/32x32/apps/aseprite.png
cp ase48.png $DIR_ICONES/48x48/apps/aseprite.png
cp ase64.png $DIR_ICONES/64x64/apps/aseprite.png
cp ase128.png $DIR_ICONES/128x128/apps/aseprite.png
cp ase256.png $DIR_ICONES/256x256/apps/aseprite.png
echo "[Desktop Entry]" > $ASEPRITE_DESKTOP
echo "Type=Application" >> $ASEPRITE_DESKTOP
echo "Name=Aseprite" >> $ASEPRITE_DESKTOP
echo "Exec=sh -c \"$HOME/aseprite/build/bin/aseprite\" " >> $ASEPRITE_DESKTOP
echo "Icon=aseprite" >> $ASEPRITE_DESKTOP
echo "Terminal=false" >> $ASEPRITE_DESKTOP
echo "Categories=Graphics;2DGraphics;" >> $ASEPRITE_DESKTOP
