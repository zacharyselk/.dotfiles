#!/usr/bin/env sh

rm -rf /home/$USER/.emacs.d/
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
/home/$USER/.emacs.d/bin/doom install
