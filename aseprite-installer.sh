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
OS_ARCH="$(arch)"
command -v apt-get > /dev/null && OS_DISTRO="debian"
command -v pacman > /dev/null && OS_DISTRO="arch"
command -v dnf > /dev/null && OS_DISTRO="fedora"
[ -z ${OS_DISTRO+x} ] && { echo "Sistema operacional não suportado. Abortando.."; exit 1; }

# Instalar dependencias
[ $OS_DISTRO = "debian" ] && sudo apt-get install -y g++ cmake ninja-build libx11-dev libxcursor-dev libxi-dev libgl1-mesa-dev libfontconfig1-dev
[ $OS_DISTRO = "arch" ] && sudo pacman -S gcc cmake ninja libx11 libxcursor mesa-libgl fontconfig unzip
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
wget -A png https://raw.githubusercontent.com/ColmeiaUDESC/Guia-Aseprite/main/aseprite.png
sudo mv aseprite.png /usr/share/icons/hicolor/48x48/apps
echo "[Desktop Entry]" | sudo tee -a /usr/share/applications/aseprite.desktop
echo "Type=Application" | sudo tee -a /usr/share/applications/aseprite.desktop
echo "Name=Aseprite" | sudo tee -a /usr/share/applications/aseprite.desktop
echo "Exec=sh -c \"$HOME/aseprite/build/bin/aseprite\" " | sudo tee -a /usr/share/applications/aseprite.desktop
echo "Icon=aseprite" | sudo tee -a /usr/share/applications/aseprite.desktop
echo "Terminal=false" | sudo tee -a /usr/share/applications/aseprite.desktop
echo "Categories=Graphics;2DGraphics;" | sudo tee -a /usr/share/applications/aseprite.desktop