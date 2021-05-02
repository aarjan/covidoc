import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';

class CovidStatusView extends StatelessWidget {
  final bool enabled;
  final int currentStatus;
  final void Function(int) onTap;
  final List<String> covidStatus;

  const CovidStatusView({
    Key key,
    this.onTap,
    this.covidStatus,
    this.currentStatus,
    this.enabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return ListTile(
        dense: true,
        trailing: Text(
          covidStatus[currentStatus],
          style: AppFonts.MEDIUM_WHITE3_16,
        ),
        title: Text(
          'Covid Status',
          style: AppFonts.MEDIUM_WHITE3_16,
        ),
      );
    }
    return Column(
      children: [
        ListTile(
          dense: true,
          onTap: () => onTap(0),
          title: Text(
            covidStatus[0],
            style: AppFonts.MEDIUM_WHITE3_16,
          ),
          trailing: Radio<int>(
            value: 0,
            groupValue: currentStatus,
            activeColor: AppColors.DEFAULT,
            onChanged: onTap,
          ),
        ),
        const Divider(),
        ListTile(
          dense: true,
          onTap: () => onTap(1),
          title: Text(
            covidStatus[1],
            style: AppFonts.MEDIUM_WHITE3_16,
          ),
          trailing: Radio<int>(
            value: 1,
            groupValue: currentStatus,
            activeColor: AppColors.DEFAULT,
            onChanged: onTap,
          ),
        ),
        const Divider(),
        ListTile(
          dense: true,
          onTap: () => onTap(2),
          title: Text(
            covidStatus[2],
            style: AppFonts.MEDIUM_WHITE3_16,
          ),
          trailing: Radio<int>(
            value: 2,
            groupValue: currentStatus,
            activeColor: AppColors.DEFAULT,
            onChanged: onTap,
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class ProfileTitleBar extends StatelessWidget {
  const ProfileTitleBar({
    Key key,
    @required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 27,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 25,
            backgroundImage: CachedNetworkImageProvider(user.avatar),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Text(
          user.fullname,
          style: AppFonts.SEMIBOLD_WHITE_16,
        ),
      ],
    );
  }
}

class PopupBtn extends StatelessWidget {
  const PopupBtn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (val) {
        context.read<AuthBloc>().add(LoggedOut());
        context.read<UserBloc>().add(ClearUser());
        Navigator.pushReplacementNamed(context, '/');
      },
      icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
      itemBuilder: (context) => [
        const PopupMenuItem(child: Text('Logout'), height: 12),
      ],
    );
  }
}
