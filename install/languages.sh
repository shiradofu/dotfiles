#!/bin/bash

if ! exists asdf; then return; fi

msg "\ninstall languages...\n"

msg "\nnodejs:\n"
asdf plugin add nodejs  &&
asdf install nodejs lts &&
asdf global nodejs lts  &&
npm install --global neovim

asdf plugin add yarn     &&
asdf install yarn latest &&
asdf global yarn latest

msg "\npython:\n"
asdf plugin add python     &&
asdf install python 2.7.18 &&
asdf shell python 2.7.18   &&
pip install pynvim

asdf install python 3.9.6  &&
asdf shell python 3.9.6    &&
pip install pynvim         &&
asdf global python 3.9.6

pip3 install neovim-remote &&
asdf reshim python

msg "\ngolang:\n"
asdf plugin add golang     &&
asdf install golang latest &&
asdf global golang latest
