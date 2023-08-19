#!/bin/bash

echo -n "" > ./lib/configs/app_assets.dart
echo "class AppAssets {" >> ./lib/configs/app_assets.dart
default_extension='Default'

function generateFileName() {
  filename=$(basename "$1")

    # Get the extension of the old file
    extension="${filename##*.}"
    # Get the old file name without the extension
    filename="${filename%.*}"
    convert_file_name=$(echo "$filename" | awk -F_ '{for (i=1; i<=NF; i++) $i=toupper(substr($i,1,1)) substr($i,2)}1' OFS=)
    convert_file_name="$(tr '[:upper:]' '[:lower:]' <<< ${convert_file_name:0:1})${convert_file_name:1}"

    if [ $default_extension != $extension ]; then 
      if [ $default_extension != 'Default' ]; then 
        echo "" >> ./lib/configs/app_assets.dart;
      fi
      echo "  // $extension" >> ./lib/configs/app_assets.dart; 
    fi
    default_extension=$extension
    echo "  static String $convert_file_name = '$1';" >> ./lib/configs/app_assets.dart
}


for path in "assets/images"/*; do
  if [[ -d $path ]]; then
    filename=$(basename "$path")
    for files in "${path}"/*; do
      generateFileName "$files"
    done
  else 
    generateFileName "$path"
  fi
done

if [[ -d "assets/videos/*" ]]; then
  for path in "assets/videos"/*; do
    if [[ -d $path ]]; then
      filename=$(basename "$path")
      for files in "${path}"/*; do
        generateFileName "$files"
      done
    else 
      generateFileName "$path"
    fi
  done
fi

echo "}" >> ./lib/configs/app_assets.dart