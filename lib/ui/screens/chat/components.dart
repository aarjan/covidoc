import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/ui/router.dart';
import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/screens/screens.dart';
import 'package:covidoc/model/entity/entity.dart';

import 'chat_request.dart';

Future showBottomQuestionSheet(BuildContext context, AppUser user) {
  return showModalBottomSheet(
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    enableDrag: true,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    shape: const RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.75,
        expand: false,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 2,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.WHITE3,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ChatRequest(
              user: user,
            ),
          ],
        ),
      );
    },
  );
}

class PendingStatus extends StatelessWidget {
  const PendingStatus({
    Key key,
    this.request,
  }) : super(key: key);

  final MessageRequest request;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.WHITE5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            request.message,
            softWrap: true,
            style: AppFonts.MEDIUM_BLACK3_16,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                request.postedAt.formattedTime,
                style: AppFonts.REGULAR_WHITE3_12,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.WHITE5,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Pending',
                  style: AppFonts.REGULAR_BLACK3_12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MsgRequest extends StatelessWidget {
  const MsgRequest({
    Key key,
    this.request,
    this.onSubmit,
  }) : super(key: key);

  final MessageRequest request;
  final void Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final patInfo =
        '${request.patDetail["gender"]}, ${request.patDetail["age"]}';
    final fullname =
        request.postedAnonymously ? 'Anonymous' : request.patDetail['fullname'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.WHITE5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              request.postedAnonymously
                  ? CircleAvatar(
                      radius: 22,
                      child: SvgPicture.asset('assets/register/patient.svg'),
                    )
                  : CircleAvatar(
                      radius: 22,
                      backgroundImage: CachedNetworkImageProvider(
                          request.patDetail['avatar']),
                    ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullname,
                      style: AppFonts.MEDIUM_BLACK3_14,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      patInfo,
                      style: AppFonts.MEDIUM_BLACK3_14,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      request.postedAt.formattedTime,
                      style: AppFonts.REGULAR_BLACK3_12,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onSubmit,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.DEFAULT,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Consult Now',
                    style: AppFonts.MEDIUM_WHITE_14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            request.message,
            softWrap: true,
            style: AppFonts.MEDIUM_BLACK3_16,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [],
          ),
        ],
      ),
    );
  }
}

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
        context.read<MessageBloc>().add(LoadMsgs(chat.id));
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
