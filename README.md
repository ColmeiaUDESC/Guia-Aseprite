# Guia de instalção Aseprite

---

Pequeno guia para compilar o Aseprite de forma gratuita e
 legal em sistemas com kernel linux

## Downloads necessários:

(Baixe os arquivos na pasta Downloads para que os scripts funcionem)


* Skia:
  * [Skia-x64](https://github.com/aseprite/skia/releases/download/m81-b607b32047/Skia-Linux-Release-x64.zip)
  * [Skia-x86](https://github.com/aseprite/skia/releases/download/m81-b607b32047/Skia-Linux-Release-x86.zip)
  
* Aseprite source code:
  * [Aseprite-v1.2.27](https://github.com/aseprite/aseprite/releases/download/v1.2.27/Aseprite-v1.2.27-Source.zip)

## Dependências:

#### Ubuntu/Debian:
```console
sudo apt-get install -y g++ cmake ninja-build libx11-dev libxcursor-dev libxi-dev libgl1-mesa-dev libfontconfig1-dev
```

#### Fedora:

```sh
sudo dnf install -y gcc-c++ cmake ninja-build libX11-devel libXcursor-devel libXi-devel mesa-libGL-devel fontconfig-devel
```

#### Arch:
```sh
sudo pacman -S gcc cmake ninja libx11 libxcursor mesa-libgl fontconfig
```

## Instalação

Copie e cole no terminal,

##### Comandos para x64:

```sh
cd ~
mkdir deps
cd deps
mkdir skia
cd ~/Downloads
sudo unzip Skia-Linux-Release-x64.zip -d ~/deps/skia
```

##### Comandos para x86:

```sh
cd ~
mkdir deps
cd deps
mkdir skia
cd ~/Downloads
sudo unzip Skia-Linux-Release-x86.zip -d ~/deps/skia
```


Repita o mesmo processo,

##### Comandos para x64:

```sh
cd ~
mkdir aseprite
cd ~/Downloads
sudo unzip Aseprite-v1.2.27-Source.zip -d ~/aseprite
cd ~/aseprite
mkdir build
cd build
cmake \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DLAF_BACKEND=skia \
  -DSKIA_DIR=$HOME/deps/skia \
  -DSKIA_LIBRARY_DIR=$HOME/deps/skia/out/Release-x64 \
  -DSKIA_LIBRARY=$HOME/deps/skia/out/Release-x64/libskia.a \
  -G Ninja \
  ..
ninja aseprite
```

##### Comandos para x86:

```sh
cd ~
mkdir aseprite
cd ~/Downloads
sudo unzip Aseprite-v1.2.27-Source.zip -d ~/aseprite
cd aseprite
mkdir build
cd build
cmake \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DLAF_BACKEND=skia \
  -DSKIA_DIR=$HOME/deps/skia \
  -DSKIA_LIBRARY_DIR=$HOME/deps/skia/out/Release-x86 \
  -DSKIA_LIBRARY=$HOME/deps/skia/out/Release-x86/libskia.a \
  -G Ninja \
  ..
ninja aseprite
```
Após compilar, o comando `ninja aseprite` estará escrito no terminal, apenas de enter e espere acabar
o processo. A esse ponto, o Aseprite está construido e pronto para ser usado, podendo abrir o programa rodando `~/aseprite/build/bin/./aseprite` . Caso queira construir o executável no menu de aplicações, continue seguindo o guia.

## Criando o .desktop:

Copie e cole no terminal,

```sh
cd ~/Downloads
wget -A png https://raw.githubusercontent.com/MrBertemes/Guia-Aseprite/main/icon.png
mv icon.png ~/../../usr/share/icons/hicolor/48x48/apps
cd ~/../../usr/share/applications/
sudo echo "[Desktop Entry]" >> aseprite.desktop
sudo echo "Type=Application" >> aseprite.desktop
sudo echo "Name=Aseprite" >> aseprite.desktop
sudo echo "Exec=sh -c "~/aseprite/build/bin/./aseprite" " >> aseprite.desktop
sudo echo "Icon=/usr/share/icons/hicolor/48x48/apps/aseprite.png" >> aseprite.desktop
sudo echo "Terminal=false" >> aseprite.desktop
```

---

Feito por: [MrBertemes](https://github.com/MrBertemes)





























