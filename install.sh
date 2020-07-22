#!/bin/bash
find ./ -maxdepth 1 -name ".[a-z]*" -type f | xargs -I{} ln `pwd`/{} $HOME/
find ./ -maxdepth 1 -name ".[a-z]*" -type d | xargs -I{} ln -s `pwd`/{} $HOME/
mkdir `pwd`/.logs
mkdir -p ../backups
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

