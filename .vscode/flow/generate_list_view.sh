#!/bin/bash

path_blocs=./lib/blocs
path_screens=./lib/screens
path_models=./lib/models
path_respositories=./lib/repositories

# Prompt the user to enter the old folder name
# read -p "Enter the old folder name: " old_folder_name

old_folder_name=template_list
# Prompt the user to enter the new folder name
read -p "Enter the name list: " new_folder_name

if [[ ! "$new_folder_name" =~ ^[a-z-]+$ ]];
then
    echo "$new_folder_name  unvalid. Please enter other name with format name1-name2 or name"
    exit 0
fi

read -p "Enter the title shown: " title

read -p "Enter the API url: " api

if [[ -d  "$path_blocs/$new_folder_name" || -d  "$path_screens/$new_folder_name" ]];
then
    echo "$new_folder_name exists. Please enter other name"
    exit 0
fi

options=("Vertical" "Horizontal" "GridView")
selected_options=1;
echo "Please enter choose number"
select option in "${options[@]}"; do
    case $option in
        "Vertical")
            echo "You chose Vertical"
            selected_options=1
            break
            ;;
        "Horizontal")
            echo "You chose Horizontal"
             selected_options=2
             break
            ;;
        "GridView")
            echo "You chose GridView"
             selected_options=3
             break
            ;;
        *) # Handle invalid options
            echo "Invalid option. Please select a number from 1 to 3."
            ;;
    esac
done

git clone https://github.com/tharro/module_flutter.git module_flutter 
cp -R module_flutter/template_list lib/blocs/
sudo rm -R module_flutter

lowercase_old_string=$(echo "$old_folder_name" | tr '[:upper:]' '[:lower:]')
lowercase_new_string=$(echo "$new_folder_name" | tr '[:upper:]' '[:lower:]')

# Capitalize first letter
old_converted_file_name=$(echo "$old_folder_name" | awk -F_ '{for (i=1; i<=NF; i++) $i=toupper(substr($i,1,1)) substr($i,2)}1' OFS=)
new_converted_file_name=$(echo "$new_folder_name" | awk -F_ '{for (i=1; i<=NF; i++) $i=toupper(substr($i,1,1)) substr($i,2)}1' OFS=)

cd $path_blocs
# Rename the folder
mv "$old_folder_name" "$new_folder_name"

# Rename the files within the folder
for file in "$new_folder_name"/*; do
  # Get the old file name without the extension
  old_file_name="${file%_*}"
  # Get the extension of the old file
  extension="${file##*_}"
 
  # Replace the old extension with the new extension
  new_file="${new_folder_name}/${new_folder_name}_${extension}"
  mv "${old_file_name}_${extension}" $new_file
  
  # Capitalize from second letter. Eg: Repositories
  oldLowerCaseFirstLetter="$(tr '[:upper:]' '[:lower:]' <<< ${old_converted_file_name:0:1})${old_converted_file_name:1}"
  newLowerCaseFirstLetter="$(tr '[:upper:]' '[:lower:]' <<< ${new_converted_file_name:0:1})${new_converted_file_name:1}"
  oldLowerCaseFirstLetter=${oldLowerCaseFirstLetter}Repositories
  newLowerCaseFirstLetter=${newLowerCaseFirstLetter}Repositories
  sed -i '' "s/${oldLowerCaseFirstLetter}/${newLowerCaseFirstLetter}/g" "$new_file"

  sed -i '' "s/${lowercase_old_string}/${lowercase_new_string}/g" "$new_file"
  sed -i '' "s/${old_converted_file_name}/${new_converted_file_name}/g" "$new_file"
done

# Create model
cd ..
cd ..
cd $path_models
mkdir $new_folder_name
cd $new_folder_name
touch ${new_folder_name}_model.dart
echo "import 'package:plugin_helper/index.dart';

class ${new_converted_file_name}Model extends Equatable {
  const ${new_converted_file_name}Model();

  ${new_converted_file_name}Model copyWith() => const ${new_converted_file_name}Model();

  factory ${new_converted_file_name}Model.fromJson(Map<String, dynamic> json) =>
      const ${new_converted_file_name}Model();

  @override
  List<Object?> get props => [];
}" >> ${new_folder_name}_model.dart

# Create screen
cd ..
cd ..
cd ..
cd $path_screens
mkdir $new_folder_name
cd $new_folder_name
touch ${new_folder_name}_page.dart
content="BlocBuilder<${new_converted_file_name}Bloc, ${new_converted_file_name}State>(
        builder: (context, state) {
          List<${new_converted_file_name}Model> list${new_converted_file_name} =
              state.list${new_converted_file_name}.results ?? [];
          return AppListViewCustom(
            $(if [ $selected_options = 2 ]; then echo "scrollDirection: Axis.horizontal,
            heightItemHorizontalLoading: 72,
            widthItemHorizontalLoading: 72,
            heightListViewHorizontal: 140,
            paddingLoadingMore: const EdgeInsets.only(
              bottom: 60, right: AppConstrains.paddingHorizontal),"; else echo ""; fi)
            onRefresh: () $(if [ $selected_options != 2 ]; then echo "{
              _getData(isFreshing: true);
            },"; else echo "=> null,"; fi)
            $(if [ $selected_options = 3 ]; then echo "padding: EdgeInsets.symmetric(
                horizontal: 16, vertical: context.safeViewBottom),
            isGridView: true,"; else echo ""; fi)
            onLoadMore: () {
              _getData(isLoadingMore: true);
            },
            data: state.list${new_converted_file_name},
            renderItem: (int index) {
              return Item${new_converted_file_name}(
                item: list${new_converted_file_name}[index],
              );
            },
          );
        },
      ),"
echo "import 'package:flutter/material.dart';
$(if [ $selected_options = 2 ]; then echo "import 'package:plugin_helper/index.dart';"; fi)

import '../../blocs/$lowercase_new_string/${lowercase_new_string}_bloc.dart';
$(if [ $selected_options = 2 ]; then echo "import '../../configs/app_constrains.dart';
import '../../configs/app_text_styles.dart';"; fi)
import '../../index.dart';
import '../../models/$lowercase_new_string/${lowercase_new_string}_model.dart';
import '../../widgets/app_list_view_custom.dart';
$(if [ $selected_options != 2 ]; then echo "import '../../widgets/header_custom.dart';"; fi)

class ${new_converted_file_name}Page extends StatefulWidget {
  const ${new_converted_file_name}Page({Key? key}) : super(key: key);

  @override
  State<${new_converted_file_name}Page> createState() => _${new_converted_file_name}PageState();
}

class _${new_converted_file_name}PageState extends State<${new_converted_file_name}Page> {
  _getData({bool isFreshing = false, bool isLoadingMore = false}) {
    BlocProvider.of<${new_converted_file_name}Bloc>(context).add(Get${new_converted_file_name}(
        isFreshing: isFreshing, isLoadingMore: isLoadingMore));
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    $(if [ $selected_options != 2 ]; then echo "
    return Scaffold(
      appBar:
          HeaderCustom(textTitle: 'key_${lowercase_new_string}'.tr()),
      body: $content
    );"; else echo "
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        22.h,
        Text('key_${lowercase_new_string}'.tr(), style: AppTextStyles.textSize14()),
        16.h,
        $content
    ]);"; fi)
  }
}

class Item${new_converted_file_name} extends StatelessWidget {
  const Item${new_converted_file_name}({Key? key, required this.item}) : super(key: key);
  final ${new_converted_file_name}Model item;

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
" >> ${new_folder_name}_page.dart

# Create translate
cd ..
cd ..
cd ..
last_chars=$(tail -c 2 ./assets/translations/en-US.json)
sed -i '' '$ s/}$//' ./assets/translations/en-US.json
sed -i '' '/^$/d' ./assets/translations/en-US.json
sed -i '' -e :a -e '/^\n*$/{$d;N;ba' -e '}' ./assets/translations/en-US.json

if echo "$last_chars" | grep -q "\"}" ; then
  echo "Success"
else
  truncate -s-1 ./assets/translations/en-US.json
  echo "Success"
fi

sed -i '' '$ s/"$/",/' ./assets/translations/en-US.json
echo "" >> ./assets/translations/en-US.json
echo "    \"key_${lowercase_new_string}\": \"$title\"" >> ./assets/translations/en-US.json
echo "" >> ./assets/translations/en-US.json
echo "}" >> ./assets/translations/en-US.json

# Create respositories
cd $path_respositories
mkdir $new_folder_name
cd $new_folder_name
touch ${new_folder_name}_repository.dart
echo "import 'package:plugin_helper/index.dart';

import '../../api/api.dart';
import '../../models/$lowercase_new_string/${lowercase_new_string}_model.dart';

class ${new_converted_file_name}Repository extends Api {
  Future<ListModel<${new_converted_file_name}Model>> get${new_converted_file_name}(
      {required String url}) async {
    final response = await request(url, Method.get);
    return ListModel.fromJson(
      response.data,
      (json) => ${new_converted_file_name}Model.fromJson(json),
    );
  }
}" >> ${new_folder_name}_repository.dart

# Add api
cd ..
cd ..
cd ..
sed -i "" -e "$ d" lib/api/apiUrl.dart
echo "  
  // ${new_converted_file_name}
  static String list${new_converted_file_name} = '\${baseUrl}${api}';" >> lib/api/apiUrl.dart 
echo "" >> lib/api/apiUrl.dart
echo "}" >> lib/api/apiUrl.dart