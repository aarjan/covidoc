import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/screens/screens.dart';
import 'package:covidoc/model/entity/entity.dart';

class RegisterScreen extends StatelessWidget {
  static const ROUTE_NAME = '/register';

  const RegisterScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.DEFAULT,
      body: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserLoadSuccess && state.userUpdated) {
              final isPatient =
                  state.user.type == describeEnum(UserType.Patient);
              Navigator.pushReplacementNamed(
                context,
                isPatient
                    ? PatientDescScreen.ROUTE_NAME
                    : DoctorDescScreen.ROUTE_NAME,
              );
            }
          },
          child: RegisterView()),
    );
  }
}

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  int choosen = -1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Who are you?',
              style: AppFonts.SEMIBOLD_BLACK3_30,
            ),
            const SizedBox(height: 63),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                UserWidget(
                  name: 'Patient',
                  inactiveImg: 'assets/patient.svg',
                  activeImg: 'assets/patient_highlighted.svg',
                  active: choosen == 0,
                  onTap: () {
                    setState(() {
                      choosen = 0;
                    });
                  },
                ),
                UserWidget(
                  name: 'Doctor',
                  active: choosen == 1,
                  inactiveImg: 'assets/doctor.svg',
                  activeImg: 'assets/doctor_highlighted.svg',
                  onTap: () {
                    setState(() {
                      choosen = 1;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  if (choosen == -1) {
                    context.toast('Please select either a Patient or a Doctor');
                    return;
                  }

                  final type = choosen == 0 ? 'Patient' : 'Doctor';
                  final user = AppUser(type: type);
                  context.read<UserBloc>().add(UpdateUser(user: user));
                },
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserWidget extends StatelessWidget {
  const UserWidget({
    Key key,
    @required this.name,
    @required this.onTap,
    @required this.active,
    @required this.activeImg,
    @required this.inactiveImg,
  }) : super(key: key);

  final String name;
  final bool active;
  final String activeImg;
  final String inactiveImg;

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: active
              ? SvgPicture.asset(activeImg)
              : SvgPicture.asset(inactiveImg),
        ),
        const SizedBox(height: 20),
        Text(name, style: AppFonts.SEMIBOLD_BLACK3_16)
      ],
    );
  }
}
