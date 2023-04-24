#!/bin/bash

cd ios
BUILD_NUMBER=$(awk "/^BUILD_NUMBER/{print $NF}" config/dev/Version.txt)
RESULT=$(sed "s/BUILD_NUMBER = //g" <<< $BUILD_NUMBER) 
INCREASE_NUMBER=$((RESULT + 1)) 
sed -i "" "s/BUILD_NUMBER = ${RESULT}/BUILD_NUMBER = ${INCREASE_NUMBER}/g" config/dev/Version.txt 
VERSION_STRING=$(awk "/^VERSION_STRING/{print $NF}" config/dev/Version.txt) 
RESULT_VERSION_STRING=$(sed "s/VERSION_STRING = //g" <<< $VERSION_STRING) 
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $INCREASE_NUMBER" "Runner/Info.plist" 
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $RESULT_VERSION_STRING" "Runner/Info.plist" 
flutter build ipa --flavor dev -t lib/main_dev.dart