#!/bin/bash

git clone https://github.com/tharro/module_flutter.git module_flutter
cp -R module_flutter/authentication/authentication_with_api/authentication_with_both/ lib/screens/auth/
cp -R module_flutter/authentication/screens/ lib/screens/auth/
cp -R module_flutter/authentication/authentication_with_api/blocs/auth lib/blocs/
cp -R module_flutter/authentication/authentication_with_api/blocs/auth_multiple/ lib/blocs/auth/
cp -R module_flutter/authentication/widgets/phone_number_custom.dart lib/widgets/
sudo rm -R module_flutter