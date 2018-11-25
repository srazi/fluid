#!/bin/bash

set -e

source /usr/local/share/liri-travis/functions

# Install packages
travis_start "install_packages"
msg "Install packages..."
dnf install -y \
    desktop-file-utils \
    libappstream-glib
travis_end "install_packages"

# Install artifacts
travis_start "artifacts"
msg "Install artifacts..."
/usr/local/bin/liri-download-artifacts $TRAVIS_BRANCH cmakeshared-artifacts.tar.gz
travis_end "artifacts"

# Configure
travis_start "configure"
msg "Setup CMake..."
mkdir build
cd build
cmake .. \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DINSTALL_LIBDIR=/usr/lib64 \
    -DINSTALL_QMLDIR=/usr/lib64/qt5/qml \
    -DINSTALL_PLUGINSDIR=/usr/lib64/qt5/plugins
travis_end "configure"

# Build
travis_start "build"
msg "Build..."
make -j $(nproc)
make install
dbus-run-session -- \
    xvfb-run -a -s "-screen 0 800x600x24" \
    ctest -V
make package
travis_end "build"

# Validate desktop file and appdata
for filename in $(find . -type f -name "*.desktop"); do
    desktop-file-validate $filename
done
for filename in $(find . -type f -name "*.appdata.xml"); do
    appstream-util validate-relax --nonet $filename
done
