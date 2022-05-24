import '../../models/item_message_model.dart';
import 'package:flutter/material.dart';

class ItemMessage extends StatelessWidget {
  final ItemMessageModel itemMessageModel;
  final String userId;
  final bool inverted;
  final int length;
  const ItemMessage({
    Key? key,
    required this.itemMessageModel,
    required this.userId,
    required this.inverted,
    required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool itsMe = itemMessageModel.senderId == userId;
    double maxWidth = MediaQuery.of(context).size.width - 150;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Directionality(
        textDirection: itsMe ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          children: [
            if (itemMessageModel.isShowDate! &&
                (!inverted ||
                    length == 1 ||
                    (itemMessageModel.isLastMessage! && inverted)))
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  itemMessageModel.dateMessage ?? '',
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!itsMe && itemMessageModel.isShowAvatar!)
                  // if (avatar != '')
                  //   CachedImage(
                  //     imageUrl: avatar,
                  //     width: 40,
                  //     isBorderRadius: true,
                  //   )
                  // else
                  const Icon(
                    Icons.support_agent,
                    size: 40,
                    color: Colors.black,
                  ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!itsMe && itemMessageModel.isShowName!)
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: !itemMessageModel.isShowAvatar! ? 40 : 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(name),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 5),
                    if (itemMessageModel.message != null)
                      Padding(
                          padding: EdgeInsets.only(
                              left: !itemMessageModel.isShowAvatar! ? 40 : 0),
                          child: Text(itemMessageModel.message!)),
                  ],
                )
              ],
            ),
            if (itemMessageModel.isShowDate! &&
                inverted &&
                length > 1 &&
                !itemMessageModel.isLastMessage!)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  itemMessageModel.dateMessage ?? '',
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget showTime({BuildContext? context, required bool itsMe}) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 5),
  //     child: Directionality(
  //         textDirection: TextDirection.ltr,
  //         child: Text(
  //           formatTime(item.createdAt),
  //           style: AppTextStyles.textSize12(
  //               context: context,
  //               color: itsMe ? Color(0xffD0D0D0) : AppColors.greyColor),
  //           textAlign: TextAlign.left,
  //         )),
  //   );
  // }
}
