#!/bin/bash

FONT=$1
scp zach@perrin.selk.io:~/git/nerd-fonts/install.sh ./ \
  && mkdir -p patched-fonts \
  && scp -r zach@perrin.selk.io:~/git/nerd-fonts/patched-fonts/${FONT} ./patched-fonts/ \
  && chmod +x install.sh \
  && ./install.sh ${FONT}
rm -rf install.sh patched-fonts
