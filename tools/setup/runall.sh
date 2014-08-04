#!/bin/bash -xe

# To bootstrap, run the following # lines:

# sudo apt-get install -y git-core
# git clone https://github.com/timvideos/streaming-system.git
# streaming-system/tools/setup/runall.sh

sudo apt-get update
streaming-system/tools/setup/00-get-timsvideo.sh

cd streaming-system/tools/setup

./01-add-multiverse.sh
./01-add-streamtime-ppa.sh
./05-update.sh
./20-gstreamer-packages.sh
./20-useful-packages.sh
./25-python-stuff.sh
./30-custom-flumotion.sh
./40-gst-plugins-dvswitch.sh
./99-remove-ppa.sh

