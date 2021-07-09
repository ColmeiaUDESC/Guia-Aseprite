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


cd ~/Downloads;
wget https://github.com/aseprite/skia/releases/download/m81-b607b32047/Skia-Linux-Release-x64.zip;
wget https://github.com/aseprite/aseprite/releases/download/v1.2.27/Aseprite-v1.2.27-Source.zip;
sudo pacman -S gcc cmake ninja libx11 libxcursor mesa-libgl fontconfig
cd ~ ;mkdir deps ;cd deps ;mkdir skia ;cd ~/Downloads ;sudo unzip Skia-Linux-Release-x64.zip -d ~/deps/skia
cd ~; mkdir aseprite ;cd ~/Downloads ;sudo unzip Aseprite-v1.2.27-Source.zip -d ~/aseprite ;cd ~/aseprite; mkdir build ;cd build; cmake \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DLAF_BACKEND=skia \
  -DSKIA_DIR=$HOME/deps/skia \
  -DSKIA_LIBRARY_DIR=$HOME/deps/skia/out/Release-x64 \
  -DSKIA_LIBRARY=$HOME/deps/skia/out/Release-x64/libskia.a \
  -G Ninja \
  ..
ninja aseprite
cd ~/Downloads ;
rm Skia-Linux-Release-x64.zip
rm Aseprite-v1.2.27-Source.zip
wget -A png https://raw.githubusercontent.com/ColmeiaUDESC/Guia-Aseprite/main/aseprite.png ;
sudo mv aseprite.png ~/../../usr/share/icons/hicolor/48x48/apps ;cd ~/../../usr/share/applications/ ;
sudo echo "[Desktop Entry]" >> aseprite.desktop ;
sudo echo "Type=Application" >> aseprite.desktop ;
sudo echo "Name=Aseprite" >> aseprite.desktop ;
sudo echo "Exec=sh -c "~/aseprite/build/bin/./aseprite" " >> aseprite.desktop ;
sudo echo "Icon=/usr/share/icons/hicolor/48x48/apps/aseprite.png" >> aseprite.desktop ;
sudo echo "Terminal=false" >> aseprite.desktop
