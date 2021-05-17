import 'package:covidoc/ui/router.dart';
import 'package:covidoc/ui/screens/chat/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/utils/const/const.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({
    Key? key,
    this.imgUrl,
    this.name,
    this.onDelete,
    required this.userId,
    required this.msgRequest,
    this.active = false,
    this.deleteCount = 0,
    this.deleteMode = false,
  }) : super(key: key);

  final String? name;
  final bool active;
  final String? imgUrl;
  final String userId;
  final bool deleteMode;
  final int deleteCount;
  final String msgRequest;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 2),
          !deleteMode
              ? Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(imgUrl!),
                        maxRadius: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(name!, style: AppFonts.SEMIBOLD_BLACK3_16),
                            Text(active ? 'Online' : 'Offline',
                                style: AppFonts.REGULAR_BLACK3_12),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : AnimatedContainer(
                  duration: const Duration(milliseconds: 1500),
                  child: Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text(
                          '$deleteCount',
                          style: AppFonts.MEDIUM_BLACK3_18,
                        )),
                        Expanded(
                          child: IconButton(
                            onPressed: onDelete,
                            icon:
                                const Icon(Icons.delete, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ChatMessagePopupMenu(
            userId: userId,
            msgRequest: msgRequest,
          ),
        ],
      ),
    );
  }
}

class ChatMessagePopupMenu extends StatelessWidget {
  const ChatMessagePopupMenu(
      {Key? key, required this.userId, required this.msgRequest})
      : super(key: key);
  final String userId;
  final String msgRequest;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (dynamic val) {
        switch (val) {
          case 'profile':
            Navigator.push(
              context,
              getRoute(
                UserProfileScreen(userId: userId, msgRequest: msgRequest),
              ),
            );
            break;
          default:
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: Text('View Profile', style: AppFonts.REGULAR_BLACK3_16),
        )
      ],
    );
  }
}
