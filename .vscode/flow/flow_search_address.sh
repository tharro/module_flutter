#!/bin/bash

git clone https://github.com/tharro/module_flutter.git module_flutter 
cp -R module_flutter/search_address/widgets/ lib/widgets/ 
cp -R module_flutter/search_address/repositories/ lib/repositories/address 
cp -R module_flutter/search_address/models/ lib/models/address 
cp -R module_flutter/search_address/blocs/ lib/blocs/ 

# Remove last line
sed -i "" -e "$ d" lib/api/apiUrl.dart
cat module_flutter/search_address/api/apiUrl.dart >> lib/api/apiUrl.dart 
echo "" >> lib/api/apiUrl.dart
echo "}" >> lib/api/apiUrl.dart


last_chars=$(tail -c 2 assets/translations/en-US.json)
sed -i '' '$ s/}$//' assets/translations/en-US.json
sed -i '' '/^$/d' assets/translations/en-US.json
sed -i '' -e :a -e '/^\n*$/{$d;N;ba' -e '}' assets/translations/en-US.json

if echo "$last_chars" | grep -q "\"}" ; then
  echo "The last character of the file is both \" and }"
else
  truncate -s-1 assets/translations/en-US.json
  echo "The last character of the file is not both \" and }"
fi

sed -i '' '$ s/"$/",/' assets/translations/en-US.json
echo "" >> assets/translations/en-US.json
cat module_flutter/search_address/assets/translations/en-US.json >> assets/translations/en-US.json
echo "" >> assets/translations/en-US.json
echo "}" >> assets/translations/en-US.json
sudo rm -R module_flutter