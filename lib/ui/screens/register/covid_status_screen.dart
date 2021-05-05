import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/screens/screens.dart';
import 'package:covidoc/ui/widgets/widgets.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/bloc/user/user_bloc.dart';

class CovidStatusScreen extends StatelessWidget {
  static const ROUTE_NAME = '/register/status';

  const CovidStatusScreen();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoadSuccess) {
          Navigator.pushNamed(context, CovidSymptomScreen.ROUTE_NAME);
        }
      },
      child: CovidStatusView(),
    );
  }
}

class CovidStatusView extends StatefulWidget {
  @override
  _CovidStatusViewState createState() => _CovidStatusViewState();
}

class _CovidStatusViewState extends State<CovidStatusView> {
  int _status = 0;

  final covidStatus = ['Positive', 'Negative', 'Not Tested'];

  void updateState(int val) {
    setState(() {
      _status = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Covid status', style: AppFonts.SEMIBOLD_BLACK3_16),
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom: ProgressBar(
            [AppColors.WHITE3, AppColors.DEFAULT, AppColors.WHITE3]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                ListTile(
                  onTap: () => updateState(0),
                  title: Text(
                    covidStatus[0],
                    style: AppFonts.MEDIUM_WHITE3_16,
                  ),
                  trailing: Radio(
                    value: 0,
                    groupValue: _status,
                    activeColor: AppColors.DEFAULT,
                    onChanged: (val) => updateState(val),
                  ),
                ),
                const Divider(),
                ListTile(
                  onTap: () => updateState(1),
                  title: Text(
                    covidStatus[1],
                    style: AppFonts.MEDIUM_WHITE3_16,
                  ),
                  trailing: Radio(
                    value: 1,
                    groupValue: _status,
                    activeColor: AppColors.DEFAULT,
                    onChanged: (val) => updateState(val),
                  ),
                ),
                const Divider(),
                ListTile(
                  onTap: () => updateState(2),
                  title: Text(
                    covidStatus[2],
                    style: AppFonts.MEDIUM_WHITE3_16,
                  ),
                  trailing: Radio(
                    value: 2,
                    groupValue: _status,
                    activeColor: AppColors.DEFAULT,
                    onChanged: (val) => updateState(val),
                  ),
                ),
                const Divider(),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  final user = AppUser(
                    detail: {'covidStatus': covidStatus[_status]},
                  );

                  context.read<UserBloc>().add(UpdateUser(user: user));
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
