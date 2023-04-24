#!/bin/bash

cd android 
./gradlew -PfinalProd 
flutter build appbundle --flavor prod -t lib/main.dart 
cd .. 
cd ios 
VERSION_NAME_INC=$(awk "/^VERSION_NAME_INC/{print $NF}" config/prod/Version.txt) 
RESULT=$(sed "s/VERSION_NAME_INC = //g" <<< $VERSION_NAME_INC) 
INCREASE_NUMBER=$((RESULT + 1)) 
sed -i "" "s/VERSION_NAME_INC = ${RESULT}/VERSION_NAME_INC = ${INCREASE_NUMBER}/g" config/prod/Version.txt 
BUILD_NUMBER=$(awk "/^BUILD_NUMBER/{print $NF}" config/prod/Version.txt) 
RESULT_BUILD_NUMBER=$(sed "s/BUILD_NUMBER = //g" <<< $BUILD_NUMBER) 
sed -i "" "s/BUILD_NUMBER = ${RESULT_BUILD_NUMBER}/BUILD_NUMBER = 1/g" config/prod/Version.txt 
VERSION_STRING=$(awk "/^VERSION_STRING/{print $NF}" config/prod/Version.txt) 
RESULT_VERSION_STRING=$(sed "s/VERSION_STRING = //g" <<< $VERSION_STRING) 
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion 1" "Runner/Info.plist" 
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${RESULT_VERSION_STRING}.${INCREASE_NUMBER}" "Runner/Info.plist" 
flutter build ipa --flavor prod -t lib/main.dart