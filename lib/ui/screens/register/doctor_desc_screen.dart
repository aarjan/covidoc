import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/screens/screens.dart';
import 'package:covidoc/ui/widgets/widgets.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/bloc/user/user_bloc.dart';

class DoctorDescScreen extends StatelessWidget {
  static const ROUTE_NAME = '/register/docDescription';

  const DoctorDescScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Describe Yourself', style: AppFonts.SEMIBOLD_BLACK3_16),
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom:
            ProgressBar([AppColors.WHITE3, AppColors.WHITE3, AppColors.WHITE3]),
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoadSuccess && state.userUpdated) {
            Navigator.pushReplacementNamed(context, HomeScreen.ROUTE_NAME);
          }
        },
        child: DocDescription(),
      ),
    );
  }
}

class DocDescription extends StatefulWidget {
  @override
  _DocDescriptionState createState() => _DocDescriptionState();
}

class _DocDescriptionState extends State<DocDescription> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _age;
  String _name;
  String _gender;
  String _location;
  String _practice;
  String _speciality;
  String _yearsOfExperience;

  List<String> years = ['1-2 years', '2-5 years', '5-10 years', '>10 years'];

  FocusScopeNode _node;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _node = FocusScope.of(context);
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormInput(
                      title: 'Name',
                      onEdit: _node.nextFocus,
                      onSave: (val) => _name = val.trim(),
                      onValidate: (val) => val.trim().isEmpty
                          ? AppConst.FULLNAME_LENGTH_ERROR
                          : null,
                    ),
                    const SizedBox(height: 16),
                    FormInput(
                      title: 'Age',
                      isNumber: true,
                      onEdit: _node.nextFocus,
                      onSave: (val) =>
                          _age = int.tryParse(val.trim(), radix: 10),
                      onValidate: (val) =>
                          val.trim().isEmpty ? AppConst.AGE_ERROR : null,
                    ),
                    const SizedBox(height: 16),
                    FormInput(
                      title: 'Gender',
                      onEdit: _node.nextFocus,
                      onSave: (val) => _gender = val.trim(),
                      onValidate: (val) =>
                          val.trim().isEmpty ? AppConst.GENDER_ERROR : null,
                    ),
                    const SizedBox(height: 16),
                    FormInput(
                      title: 'Location',
                      onEdit: _node.nextFocus,
                      onSave: (val) => _location = val.trim(),
                      onValidate: (val) =>
                          val.trim().isEmpty ? AppConst.LOCATION_ERROR : null,
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Profession info',
                      textAlign: TextAlign.start,
                      style: AppFonts.MEDIUM_WHITE3_12,
                    ),
                    const SizedBox(height: 16),
                    FormInput(
                      title: 'Speciality',
                      onEdit: _node.nextFocus,
                      onSave: (val) => _speciality = val.trim(),
                      onValidate: (val) => val.trim().isEmpty
                          ? AppConst.SPECIALITY_LENGTH_ERROR
                          : null,
                    ),
                    const SizedBox(height: 16),
                    FormInput(
                      title: 'Hospital or Clinic',
                      onEdit: _node.nextFocus,
                      onSave: (val) => _practice = val.trim(),
                      onValidate: (val) => val.trim().isEmpty
                          ? AppConst.PRACTICE_LENGTH_ERROR
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Years of Experience',
                          style: AppFonts.MEDIUM_BLACK3_16,
                        )),
                        DropdownButton(
                          value: _yearsOfExperience ?? years[0],
                          underline: const SizedBox.shrink(),
                          items: years
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _yearsOfExperience = val;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  _formKey.currentState.save();
                  FocusScope.of(context).unfocus();

                  if (_formKey.currentState.validate()) {
                    final user = AppUser(
                      fullname: _name,
                      detail: {
                        'age': _age,
                        'gender': _gender,
                        'location': _location,
                        'practice': _practice,
                        'speciality': _speciality,
                        'yearsOfExperience': _yearsOfExperience,
                      },
                    );
                    context
                        .read<UserBloc>()
                        .add(UpdateUser(user: user, persist: true));
                  }
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
