#!/bin/bash

if [ -f "lib/screens/auth/options_verify.dart" ]; then rm -Rf lib/screens/auth/options_verify.dart; fi 
if [ -f "lib/widgets/phone_number_custom.dart" ]; then rm -Rf lib/widgets/phone_number_custom.dart; fi 
git clone https://github.com/tharro/module_flutter.git module_flutter 
cp -R module_flutter/authentication/authentication_with_api/authentication_with_email/ lib/screens/auth/ 
cp -R module_flutter/authentication/screens/ lib/screens/auth/ 
cp -R module_flutter/authentication/authentication_with_api/blocs/auth lib/blocs/ 
cp -R module_flutter/authentication/authentication_with_api/blocs/auth_single/ lib/blocs/auth/ 
sudo rm -R module_flutter