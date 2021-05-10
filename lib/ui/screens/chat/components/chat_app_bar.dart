import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/utils/const/const.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({
    Key key,
    this.imgUrl,
    this.name,
    this.active = false,
  }) : super(key: key);

  final String name;
  final bool active;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 2),
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(imgUrl),
              maxRadius: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(name, style: AppFonts.SEMIBOLD_BLACK3_16),
                  const SizedBox(height: 6),
                  Text(active ? 'Online' : 'Offline',
                      style: AppFonts.REGULAR_BLACK3_12),
                ],
              ),
            ),
            const Icon(Icons.settings, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
