#!/bin/bash
set -e

# openjfx is available in the testing repo
echo 'deb http://mirrordirector.raspbian.org/raspbian/ stretch main contrib non-free rpi' | sudo tee -a /etc/apt/sources.list >/dev/null
sudo apt-get update
sudo apt-get install openjdk-8-jdk openjfx maven tor -y

mkdir -p ~/src

# build bitcoinj
cd ~/src
[[ -d bitcoinj ]] || git clone -b FixBloomFilters https://github.com/bitsquare/bitcoinj.git
cd bitcoinj; git pull
mvn clean install -DskipTests -Dmaven.javadoc.skip=true

# build bitsquare
cd ~/src
[[ -d bitsquare ]] || git clone https://github.com/bitsquare/bitsquare.git
cd bitsquare/; git pull

wget https://github.com/SjonHortensius/bitsquare/commit/338f7f117939ecc2fc302c3d57079f6c81c851a7.patch || :
patch -p1 <338f7f117939ecc2fc302c3d57079f6c81c851a7.patch || :

mvn clean package -DskipTests

echo -e 'Run this script again to update from github. Run this command to start Bitsquare:\n\t/usr/bin/java -jar ~/src/bitsquare/gui/target/shaded.jar'
