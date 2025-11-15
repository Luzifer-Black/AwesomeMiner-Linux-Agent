#!/usr/bin/env bash
set -e
VER=${1:-1.1}
WORK=$(pwd)
BUILD=rootfs
rm -rf $BUILD; mkdir -p $BUILD/opt/awesomeagent
cp -a ../gui ../backend ../tools ../systemd ../scripts ../README.md ../LICENSE ../requirements.txt $BUILD/opt/awesomeagent/
mkdir -p $BUILD/DEBIAN
cat > $BUILD/DEBIAN/control <<EOF
Package: awesomeagent
Version: ${VER}
Section: utils
Priority: optional
Architecture: amd64
Depends: python3, python3-requests
Maintainer: Luzifer-Black <noreply@example.com>
Description: AwesomeAgent GUI & Agent
EOF
dpkg-deb --build $BUILD "awesomeagent_${VER}_amd64.deb"
echo "Built awesomeagent_${VER}_amd64.deb"
