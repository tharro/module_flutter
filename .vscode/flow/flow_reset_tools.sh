#!/bin/bash

git clone https://github.com/tharro/module_flutter.git module_flutter 
rm -r .vscode
cp -R module_flutter/.vscode .vscode
sudo rm -R module_flutter