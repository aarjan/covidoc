import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/widgets/widgets.dart';
import 'package:covidoc/bloc/user/user_bloc.dart';
import 'package:covidoc/model/entity/app_user.dart';

import 'components.dart';

class ProfileScreen extends StatefulWidget {
  static const ROUTE_NAME = '/user';
  const ProfileScreen();

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _enabled = false;

  int _age;
  String _gender;
  String _location;
  String _language;
  String _symptoms;
  String _practice;
  String _speciality;
  String _yearsOfExperience;

  AppUser _user;
  int _status = 0;
  FocusScopeNode _node;

  final covidStatus = ['Positive', 'Negative', 'Not Tested'];
  List<String> years = ['1-2 years', '2-5 years', '5-10 years', '>10 years'];

  void init(AppUser user) {
    _user = _user ?? user;
    _age = _age ?? user.detail['age'];
    _gender = _gender ?? user.detail['gender'];
    _language = _language ?? user.detail['language'];
    _location = _location ?? user.detail['location'];
    _symptoms = _symptoms ?? user.detail['symptoms'];
    _practice = _practice ?? user.detail['practice'];
    _speciality = _speciality ?? user.detail['speciality'];
    _yearsOfExperience =
        _yearsOfExperience ?? user.detail['_yearsOfExperience'];
  }

  void updateState(int val) {
    setState(() {
      _status = val;
    });
  }

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
    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoadSuccess && state.userUpdated) {
            context.toast('User updated successfully!');
          }
        },
        builder: (context, state) {
          if (state is UserLoadSuccess) {
            init(state.user);
          }
          if (_user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  mAppBar(_user),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 20),
                      _user.type == describeEnum(UserType.Patient)
                          ? buildPatientForm()
                          : buildDoctorForm(),
                    ]),
                  ),
                ],
              ),
              if (state is UserLoadInProgress)
                const Center(child: CircularProgressIndicator())
            ],
          );
          },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_enabled) {
            _formKey.currentState.save();

            if (_formKey.currentState.validate()) {
              final nUser = AppUser(
                detail: {
                  'age': _age,
                  'gender': _gender,
                  'language': _language,
                  'location': _location,
                  'symptoms': _symptoms,
                  'covidStatus': _status,
                  'practice': _practice,
                  'speciality': _speciality,
                  'yearsOfExperience': _yearsOfExperience,
                },
                profileVerification: true,
              );
              context
                  .read<UserBloc>()
                  .add(UpdateUser(user: nUser, persist: true));
            }
          }

          setState(() {
            _enabled = !_enabled;
          });
        },
        child: _enabled
            ? const Icon(Icons.beenhere_rounded, color: Colors.white)
            : const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Form buildPatientForm() {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CovidStatusView(
                onTap: updateState,
                currentStatus: _status,
                enabled: _enabled,
                covidStatus: covidStatus,
              ),
              const SizedBox(height: 16),
              FormInput(
                title: 'Age',
                isNumber: true,
                onEdit: _node.nextFocus,
                enabled: _enabled,
                initialValue: _age.toString(),
                onSave: (val) => _age = int.tryParse(val.trim(), radix: 10),
                onValidate: (val) =>
                    val.trim().isEmpty ? AppConst.AGE_ERROR : null,
              ),
              const SizedBox(height: 16),
              FormInput(
                title: 'Gender',
                initialValue: _gender,
                onEdit: _node.nextFocus,
                enabled: _enabled,
                onSave: (val) => _gender = val.trim(),
                onValidate: (val) =>
                    val.trim().isEmpty ? AppConst.GENDER_ERROR : null,
              ),
              const SizedBox(height: 16),
              FormInput(
                title: 'Location',
                initialValue: _location,
                onEdit: _node.nextFocus,
                enabled: _enabled,
                onSave: (val) => _location = val.trim(),
                onValidate: (val) =>
                    val.trim().isEmpty ? AppConst.FULLNAME_LENGTH_ERROR : null,
              ),
              const SizedBox(height: 16),
              FormInput(
                title: 'Language',
                initialValue: _language,
                onEdit: _node.nextFocus,
                enabled: _enabled,
                onSave: (val) => _language = val.trim(),
                onValidate: (val) =>
                    val.trim().isEmpty ? AppConst.FULLNAME_LENGTH_ERROR : null,
              ),
              const SizedBox(height: 16),
              FormInput(
                title: 'Symptoms',
                minLines: 5,
                maxLines: 10,
                enabled: _enabled,
                initialValue: _symptoms,
                onEdit: _node.nextFocus,
                onSave: (val) => _symptoms = val.trim(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ));
  }

  Form buildDoctorForm() {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              FormInput(
                title: 'Age',
                isNumber: true,
                onEdit: _node.nextFocus,
                enabled: _enabled,
                initialValue: _age.toString(),
                onSave: (val) => _age = int.tryParse(val.trim(), radix: 10),
                onValidate: (val) =>
                    val.trim().isEmpty ? AppConst.AGE_ERROR : null,
              ),
              const SizedBox(height: 16),
              FormInput(
                title: 'Gender',
                initialValue: _gender,
                onEdit: _node.nextFocus,
                enabled: _enabled,
                onSave: (val) => _gender = val.trim(),
                onValidate: (val) =>
                    val.trim().isEmpty ? AppConst.GENDER_ERROR : null,
              ),
              const SizedBox(height: 16),
              FormInput(
                title: 'Location',
                initialValue: _location,
                onEdit: _node.nextFocus,
                enabled: _enabled,
                onSave: (val) => _location = val.trim(),
                onValidate: (val) =>
                    val.trim().isEmpty ? AppConst.FULLNAME_LENGTH_ERROR : null,
              ),
              const SizedBox(height: 16),
              FormInput(
                title: 'Speciality',
                initialValue: _speciality,
                onEdit: _node.nextFocus,
                enabled: _enabled,
                onSave: (val) => _speciality = val.trim(),
                onValidate: (val) => val.trim().isEmpty
                    ? AppConst.SPECIALITY_LENGTH_ERROR
                    : null,
              ),
              const SizedBox(height: 16),
              FormInput(
                title: 'Hospital or Clinic',
                enabled: _enabled,
                initialValue: _practice,
                onEdit: _node.nextFocus,
                onSave: (val) => _practice = val.trim(),
              ),
              const SizedBox(height: 16),
              Row(children: [
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
                )
              ]),
              const SizedBox(height: 50),
            ],
          ),
        ));
  }

  SliverAppBar mAppBar(AppUser user) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 200,
      actions: [
        const PopupBtn(),
      ],
      leading: null,
      leadingWidth: 0,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.DEFAULT,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 10),
        title: ProfileTitleBar(user: user),
      ),
    );
  }
}
