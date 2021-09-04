#!/bin/bash

msg "\ninstall languages...\n"

msg "\nnodejs:\n"
asdf plugin add nodejs
asdf install nodejs lts
asdf global nodejs lts

asdf plugin add yarn
asdf install yarn latest
asdf global yarn latest

msg "\npython:\n"
asdf plugin add python
asdf install python 2.7.18
asdf install python 3.9.6
asdf global python 3.9.6

npm install --global neovim
asdf shell python 2.7.18
pip install pynvim
asdf shell python 3.9.6
pip install pynvim
pip3 install neovim-remote
asdf reshim python

msg "\ngolang:\n"
asdf plugin add golang
asdf install golang latest
asdf global golang latest
