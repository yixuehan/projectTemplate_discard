#!/bin/bash
sudo dpkg --add-architecture i386
wget https://dl.winehq.org/wine-builds/Release.key
sudo apt-key add Release.key
sudo apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
sudo apt-get install --install-recommends winehq-stable
