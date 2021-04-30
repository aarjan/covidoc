import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';

class DoctorListView extends StatelessWidget {
  const DoctorListView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoadSuccess) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.doctors.length,
            itemBuilder: (context, index) {
              final user = state.user;
              final doctor = state.doctors[index];
              return _DoctorItem(
                user: doctor,
                onConnect: () {
                  context.read<MessageBloc>().add(LoadMsgs(user.id, doctor.id));

                  context.read<ChatBloc>().add(
                        StartChat(Chat(
                          patId: user.id,
                          patName: user.fullname,
                          patAvatar: user.avatar,
                          docId: doctor.id,
                          docAvatar: doctor.avatar,
                          docName: doctor.fullname,
                        )),
                      );
                },
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _DoctorItem extends StatelessWidget {
  final AppUser user;
  final void Function() onConnect;

  const _DoctorItem({Key key, this.user, this.onConnect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(user.avatar),
      ),
      title: Text(user.fullname),
      subtitle: Text(user.type),
      trailing: InkWell(
        onTap: onConnect,
        borderRadius: BorderRadius.circular(6),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.GREEN1,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.all(10),
          child: Text(
            'Connect',
            style: AppFonts.MEDIUM_BLACK3_14,
          ),
        ),
      ),
    );
  }
}
