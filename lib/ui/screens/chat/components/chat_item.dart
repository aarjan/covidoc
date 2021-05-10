import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/ui/router.dart';
import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/screens/screens.dart';
import 'package:covidoc/model/entity/entity.dart';

class ChatItem extends StatelessWidget {
  const ChatItem(this.chat, this.isFromPatient);

  final Chat chat;
  final bool isFromPatient;

  @override
  Widget build(BuildContext context) {
    final unReadCount =
        isFromPatient ? chat.patUnreadCount : chat.docUnreadCount ?? 4;

    return ListTile(
      onTap: () {
        context.read<MessageBloc>().add(LoadMsgs(chatId: chat.id));
        Navigator.push(context,
            getRoute(ChatScreen(chat: chat, isFromPatient: isFromPatient)));
      },
      leading: CircleAvatar(
        radius: 22,
        backgroundImage: CachedNetworkImageProvider(
            isFromPatient ? chat.docAvatar : chat.patAvatar),
      ),
      title: Text(
        isFromPatient ? chat.docName : chat.patName,
        style: AppFonts.SEMIBOLD_BLACK3_16,
      ),
      subtitle: Text(
        chat.lastMessage ?? AppConst.NO_CONVERSATION_TXT,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppFonts.REGULAR_WHITE3_12.copyWith(color: AppColors.WHITE2),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            chat.lastTimestamp?.formattedTime ?? 'Today',
            style: AppFonts.REGULAR_WHITE3_12.copyWith(color: AppColors.WHITE2),
          ),
          if (unReadCount > 0)
            Container(
              decoration: BoxDecoration(
                color: AppColors.DEFAULT,
                borderRadius: BorderRadius.circular(2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child:
                  Text(unReadCount.toString(), style: AppFonts.BOLD_WHITE_14),
            ),
        ],
      ),
    );
  }
}
