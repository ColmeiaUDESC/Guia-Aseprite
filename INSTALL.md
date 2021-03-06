# Guia de instalação Aseprite

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
sudo pacman -S gcc cmake ninja libx11 libxcursor mesa-libgl fontconfig unzip
```

## Instalação

Copie e cole no terminal,

##### Comandos para x64:

```sh
cd ~ ;mkdir deps ;cd deps ;mkdir skia ;cd ~/Downloads ;sudo unzip Skia-Linux-Release-x64.zip -d ~/deps/skia
```

##### Comandos para x86:

```sh
cd ~ ;mkdir deps ;cd deps ;mkdir skia ;cd ~/Downloads ;sudo unzip Skia-Linux-Release-x86.zip -d ~/deps/skia
```


Repita o mesmo processo,

##### Comandos para x64:

```sh
cd ~; mkdir aseprite ;cd ~/Downloads ;sudo unzip Aseprite-v1.2.27-Source.zip -d ~/aseprite ;cd ~/aseprite; mkdir build ;cd build; cmake \
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
cd ~; mkdir aseprite ;cd ~/Downloads ;sudo unzip Aseprite-v1.2.27-Source.zip -d ~/aseprite ;cd ~/aseprite; mkdir build ;cd build; cmake \
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

Após compilar o Aseprite, rode o seguinte comando no terminal para criar um .desktop para o usuário atual:

```sh
cd $HOME/aseprite/build/bin/data/icons; cp ase16.png $HOME/.local/share/icons/hicolor/16x16/apps/aseprite.png; cp ase32.png $HOME/.local/share/icons/hicolor/32x32/apps/aseprite.png; cp ase48.png $HOME/.local/share/icons/hicolor/48x48/apps/aseprite.png; cp ase64.png $HOME/.local/share/icons/hicolor/64x64/apps/aseprite.png; cp ase128.png $HOME/.local/share/icons/hicolor/128x128/apps/aseprite.png; cp ase256.png $HOME/.local/share/icons/hicolor/256x256/apps/aseprite.png; $HOME/.local/share/applications/ ;echo "[Desktop Entry]" > aseprite.desktop ;echo "Type=Application" >> aseprite.desktop ;echo "Name=Aseprite" >> aseprite.desktop ;echo "Exec=sh -c "~/aseprite/build/bin/./aseprite" " >> aseprite.desktop ;echo "Icon=aseprite" >> aseprite.desktop ;echo "Terminal=false">> aseprite.desktop; echo "Categories=Graphics;2DGraphics;" >> aseprite.desktop

```

## Desinstalação

Para desinstalar o Aseprite, basta ir até a pasta de instalação do aseprite (na pasta /home/nomedousuario) e apague a diretório "aseprite":

```sh
sudo rm -r ~/aseprite
```

Caso deseje apagar o Skia, uma das dependências necessárias para compilar o Aseprite, navegue até o diretório /home/nomedousuario/deps e apague o diretório nomeado "skia" (ou apague o diretório deps caso o skia seja a sua única subpasta)

```sh
sudo rm -r ~/deps/skia
ou
sudo rm -r ~/deps/
```

Para apagar o icone, execute os seguintes comandos no terminal:

```sh
sudo rm /usr/share/applications/aseprite.desktop
sudo rm /usr/share/icons/hicolor/48x48/apps/aseprite.png
```



















