#!/bin/bash

git clone https://github.com/tharro/module_flutter.git module_flutter 
cp -R module_flutter/main_tab lib/screens/ 
sudo rm -R module_flutter