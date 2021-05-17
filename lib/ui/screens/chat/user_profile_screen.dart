import 'package:cached_network_image/cached_network_image.dart';
import 'package:covidoc/bloc/auth/auth.dart';
import 'package:covidoc/bloc/user/user_bloc.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/repo.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileScreen extends StatelessWidget {
  static const ROUTE_NAME = 'chat/userProfile';

  final String userId;
  final String msgRequest;
  const UserProfileScreen(
      {Key? key, required this.userId, required this.msgRequest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => UserBloc(
            repo: context.read<UserRepo>(), authBloc: context.read<AuthBloc>())
          ..add(LoadUser(userId: userId)),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoadSuccess) {
              return UserProfile(
                user: state.user,
                msgRequest: msgRequest,
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({
    Key? key,
    required this.user,
    required this.msgRequest,
  }) : super(key: key);

  final AppUser user;
  final String msgRequest;

  @override
  Widget build(BuildContext context) {
    final isPatient = user.type == describeEnum(UserType.Patient);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          stretch: true,
          leading: const BackButton(color: Colors.white),
          expandedHeight: 300.0,
          backgroundColor: AppColors.DEFAULT,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: <StretchMode>[
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
              StretchMode.fadeTitle,
            ],
            centerTitle: false,
            title: Text(
              user.fullname!,
              style: AppFonts.BOLD_WHITE_18,
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: user.avatar!,
                  fit: BoxFit.cover,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.0, 0.5),
                      end: Alignment(0.0, 0.0),
                      colors: <Color>[
                        Color(0x60000000),
                        Color(0x00000000),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            ([
              const SizedBox(
                height: 30,
              ),
              if (isPatient)
                Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Consultation Message',
                        textAlign: TextAlign.start,
                        style: AppFonts.MEDIUM_BLACK3_16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title:
                          Text(msgRequest, style: AppFonts.REGULAR_BLACK3_14),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ListTile(
                title: Text(user.detail!['age'].toString(),
                    style: AppFonts.MEDIUM_BLACK3_14),
                subtitle: Text('Age', style: AppFonts.REGULAR_WHITE2_11),
              ),
              const Divider(),
              ListTile(
                title: Text(user.detail!['gender'],
                    style: AppFonts.MEDIUM_BLACK3_14),
                subtitle: Text('Gender', style: AppFonts.REGULAR_WHITE2_11),
              ),
              const Divider(),
              ListTile(
                title: Text(user.detail!['language'],
                    style: AppFonts.MEDIUM_BLACK3_14),
                subtitle: Text('Language', style: AppFonts.REGULAR_WHITE2_11),
              ),
              const Divider(),
              ListTile(
                title: Text(user.detail!['location'],
                    style: AppFonts.MEDIUM_BLACK3_14),
                subtitle: Text('Location', style: AppFonts.REGULAR_WHITE2_11),
              ),
              const Divider(),
              isPatient
                  ? PatientInfo(detail: user.detail)
                  : DoctorInfo(detail: user.detail!),
              const Divider(
                thickness: 10,
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.block, color: Colors.red[800]),
                title: Text(
                  'Block',
                  style: AppFonts.MEDIUM_BLACK3_14
                      .copyWith(color: Colors.red[800]),
                ),
              ),
              const Divider(
                thickness: 10,
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.thumb_down, color: Colors.red[800]),
                title: Text(
                  'Report Contact',
                  style: AppFonts.MEDIUM_BLACK3_14
                      .copyWith(color: Colors.red[800]),
                ),
              ),
              const Divider(
                thickness: 10,
              ),
              const SizedBox(
                height: 60,
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class PatientInfo extends StatelessWidget {
  const PatientInfo({Key? key, this.detail}) : super(key: key);
  final Map<String, dynamic>? detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(detail!['covidStatus'].toString(),
              style: AppFonts.MEDIUM_BLACK3_14),
          subtitle: Text('CovidStatus', style: AppFonts.REGULAR_WHITE2_11),
        ),
        const Divider(),
        ListTile(
          title: Text(detail!['symptoms'], style: AppFonts.MEDIUM_BLACK3_14),
          subtitle: Text('Symptoms', style: AppFonts.REGULAR_WHITE2_11),
        ),
      ],
    );
  }
}

class DoctorInfo extends StatelessWidget {
  const DoctorInfo({Key? key, required this.detail}) : super(key: key);
  final Map<String, dynamic> detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        ListTile(
          title: Text(detail['yearsOfExperience'],
              style: AppFonts.MEDIUM_BLACK3_14),
          subtitle:
              Text('Years of Experience', style: AppFonts.REGULAR_WHITE2_11),
        ),
        const Divider(),
        ListTile(
          title: Text(detail['speciality'], style: AppFonts.MEDIUM_BLACK3_14),
          subtitle: Text('Speciality', style: AppFonts.REGULAR_WHITE2_11),
        ),
        const Divider(),
        ListTile(
          title: Text(detail['practice'], style: AppFonts.MEDIUM_BLACK3_14),
          subtitle: Text('Practice', style: AppFonts.REGULAR_WHITE2_11),
        ),
      ],
    );
  }
}
