#!/bin/bash

cd ios 
VERSION_NAME_INC=$(awk "/^VERSION_NAME_INC/{print $NF}" config/prod/Version.txt) 
RESULT_VERSION_NAME_INC=$(sed "s/VERSION_NAME_INC = //g" <<< $VERSION_NAME_INC) 
BUILD_NUMBER=$(awk "/^BUILD_NUMBER/{print $NF}" config/prod/Version.txt) 
RESULT=$(sed "s/BUILD_NUMBER = //g" <<< $BUILD_NUMBER) 
INCREASE_NUMBER=$((RESULT + 1)) 
sed -i "" "s/BUILD_NUMBER = ${RESULT}/BUILD_NUMBER = ${INCREASE_NUMBER}/g" config/prod/Version.txt 
VERSION_STRING=$(awk "/^VERSION_STRING/{print $NF}" config/prod/Version.txt) 
RESULT_VERSION_STRING=$(sed "s/VERSION_STRING = //g" <<< $VERSION_STRING) 
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $INCREASE_NUMBER" "Runner/Info.plist" 
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${RESULT_VERSION_STRING}.${RESULT_VERSION_NAME_INC}" "Runner/Info.plist" 
flutter build ipa --flavor prod -t lib/main.dart