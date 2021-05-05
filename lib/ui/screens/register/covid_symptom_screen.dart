import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/ui/router.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/screens/screens.dart';
import 'package:covidoc/ui/widgets/widgets.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/bloc/user/user_bloc.dart';

class CovidSymptomScreen extends StatelessWidget {
  static const ROUTE_NAME = '/register/symptom';

  const CovidSymptomScreen();
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoadSuccess) {
            Navigator.pushAndRemoveUntil(
                context, getRoute(const HomeScreen()), (route) => false);
          }
        },
        child: const CovidSymptomView());
  }
}

class CovidSymptomView extends StatefulWidget {
  const CovidSymptomView();

  @override
  _CovidSymptomViewState createState() => _CovidSymptomViewState();
}

class _CovidSymptomViewState extends State<CovidSymptomView> {
  String _txt;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Covid symptoms', style: AppFonts.SEMIBOLD_BLACK3_16),
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom: ProgressBar(
            [AppColors.WHITE3, AppColors.WHITE3, AppColors.DEFAULT]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
                onSaved: (val) => _txt = val.trim(),
                maxLines: 10,
                autofocus: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                  hintStyle: AppFonts.MEDIUM_WHITE3_16,
                  hintText: 'Describe here...',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    _formKey.currentState.save();
                    FocusScope.of(context).unfocus();

                    final user = AppUser(
                      profileVerification: true,
                      detail: {'symptoms': _txt},
                    );
                    context
                        .read<UserBloc>()
                        .add(UpdateUser(user: user, persist: true));
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
