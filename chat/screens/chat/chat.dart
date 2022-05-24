import '../../blocs/chat/chat_bloc.dart';
import '../../configs/app_text_styles.dart';
import '../../models/item_message_model.dart';
import '../../screens/auth/item_message.dart';
import '../../utils/helper.dart';
import '../../widgets/bottom_appbar_custom.dart';
import '../../widgets/button_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plugin_helper/plugin_helper.dart';
import 'package:plugin_helper/plugin_picker_file.dart';
import 'package:plugin_helper/widgets/widget_app_list_view.dart';
import 'package:easy_localization/easy_localization.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FocusNode _chatNode = FocusNode();
  final TextEditingController _chatController = TextEditingController();
  bool inverted = true;
  List<ItemMessageModel> list = [
    ItemMessageModel(
        message: '1234',
        senderId: '1',
        createdAt: '2022-05-20T08:14:16.234Z',
        chatId: 'zxc'),
    ItemMessageModel(
        message: '1234',
        senderId: '2',
        createdAt: '2022-05-21T08:14:16.234Z',
        chatId: 'zxc'),
  ];
  @override
  void initState() {
    _chatController.addListener(_onChangeText);
    _showDate(list);
    super.initState();
  }

  _onChangeText() {
    BlocProvider.of<ChatBloc>(context).add(HandleToolBar(
        isSendText: _chatController.text.trim().isNotEmpty,
        numLine: '\n'.allMatches(_chatController.text).length + 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 16,
          centerTitle: false,
          title: Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(50)),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tharo',
                    style: AppTextStyles.textSize12(),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Online',
                        style: AppTextStyles.textSize12(),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBarCustom(
            padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return Row(
                  crossAxisAlignment: state.numLine == 1
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Helper.showModalBottom(
                            context: context,
                            maxHeight: 150,
                            child: Column(
                              children: [
                                ButtonCustom(
                                    width: 200,
                                    title: 'key_camera'.tr(),
                                    onPressed: () {
                                      _uploadImage(true);
                                    }),
                                const SizedBox(height: 10),
                                ButtonCustom(
                                    width: 200,
                                    title: 'key_gallery'.tr(),
                                    onPressed: () {
                                      _uploadImage(false);
                                    })
                              ],
                            ));
                      },
                      child: const Icon(
                        Icons.image,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () async {
                        await MyPluginPickerFile.pickerFileCustom();
                      },
                      child: const Icon(
                        Icons.attach_file,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                          controller: _chatController,
                          focusNode: _chatNode,
                          maxLines: 5,
                          minLines: 1,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 1)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            filled: true,
                            hintText: 'Message...',
                            fillColor: const Color(0xffF4F4F4),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                          )),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {
                          if (state.isSendText!) {
                            //TODO
                          }
                        },
                        child: Icon(
                          Icons.send,
                          size: 25,
                          color: state.isSendText! ? Colors.green : Colors.grey,
                        ))
                  ],
                );
              },
            )),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: MyWidgetAppListView(
                    data: list,
                    reverse: true,
                    renderItem: (int index) {
                      return ItemMessage(
                          itemMessageModel: list[index],
                          userId: '1',
                          inverted: inverted,
                          length: list.length);
                    }))
          ],
        ));
  }

  void _uploadImage(bool isCamera) async {
    Navigator.pop(context);
    if (!isCamera) {
      List<PickedFile>? pickers =
          await Helper.pickMultipleImage(context: context);
      //TODO
    } else {
      PickedFile? picker = await Helper.pickSingleImage(
          context: context, isFromCamera: isCamera);
      //TODO
    }
  }

  void _showDate(List<ItemMessageModel> _mess) {
    DateTime? currentDate;
    _mess.asMap().entries.forEach((element) {
      bool showDate, showAvatar, showName = false;
      bool last = _mess.length - 1 == element.key, isFirst = element.key == 0;
      final message = element.value;
      final nextMessage = last ? null : _mess[element.key + 1];
      final previousMessage = isFirst ? null : _mess[element.key - 1];

      DateTime messageDate = DateTime.parse(element.value.createdAt).toLocal();
      // Needed for inverted list
      DateTime previousDate = currentDate ?? messageDate;
      if (currentDate == null) {
        currentDate = messageDate;
        showDate = !inverted && _mess.length == 1;
      } else if (currentDate!.difference(messageDate).inDays != 0) {
        showDate = true;
        currentDate = messageDate;
      } else if (element.key == _mess.length - 1 && inverted) {
        showDate = true;
      } else {
        showDate = false;
      }

      if (message.senderId != nextMessage?.senderId) {
        showName = true;
      }

      if (isFirst ||
          (message.senderId != previousMessage?.senderId &&
              message.senderId != nextMessage?.senderId) ||
          (message.senderId != previousMessage?.senderId &&
              message.senderId == nextMessage?.senderId)) {
        showAvatar = true;
      } else {
        showAvatar = false;
      }

      ItemMessageModel itm = _mess[element.key].copyWith(
        isShowDate: showDate,
        isLastMessage: last,
        dateMessage: previousDate.toString(),
        isShowAvatar: showAvatar,
        isShowName: showName,
      );
      _mess[element.key] = itm;
    });
    list = _mess;
  }
}
