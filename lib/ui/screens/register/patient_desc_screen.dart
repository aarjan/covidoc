import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/bloc/user/user_bloc.dart';
import 'package:covidoc/ui/widgets/widgets.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:covidoc/ui/screens/register/covid_status_screen.dart';

class PatientDescScreen extends StatelessWidget {
  const PatientDescScreen();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoadSuccess) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CovidStatusScreen()));
        }
      },
      child: PatientDescription(),
    );
  }
}

class PatientDescription extends StatefulWidget {
  @override
  _PatientDescriptionState createState() => _PatientDescriptionState();
}

class _PatientDescriptionState extends State<PatientDescription> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _age;
  String _name;
  String _gender;
  String _location;
  String _language;

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Describe Yourself', style: AppFonts.SEMIBOLD_BLACK3_16),
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom: ProgressBar(
            [AppColors.DEFAULT, AppColors.WHITE3, AppColors.WHITE3]),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FormInput(
                        title: 'Name',
                        onEdit: node.nextFocus,
                        onSave: (val) => _name = val.trim(),
                        onValidate: (val) => val.trim().isEmpty
                            ? AppConst.FULLNAME_LENGTH_ERROR
                            : null,
                      ),
                      const SizedBox(height: 16),
                      FormInput(
                        title: 'Age',
                        isNumber: true,
                        onEdit: node.nextFocus,
                        onSave: (val) =>
                            _age = int.tryParse(val.trim(), radix: 10),
                        onValidate: (val) =>
                            val.trim().isEmpty ? AppConst.AGE_ERROR : null,
                      ),
                      const SizedBox(height: 16),
                      FormInput(
                        title: 'Gender',
                        onEdit: node.nextFocus,
                        onSave: (val) => _gender = val.trim(),
                        onValidate: (val) =>
                            val.trim().isEmpty ? AppConst.GENDER_ERROR : null,
                      ),
                      const SizedBox(height: 16),
                      FormInput(
                        title: 'Location',
                        onEdit: node.nextFocus,
                        onSave: (val) => _location = val.trim(),
                        onValidate: (val) => val.trim().isEmpty
                            ? AppConst.FULLNAME_LENGTH_ERROR
                            : null,
                      ),
                      const SizedBox(height: 16),
                      FormInput(
                        title: 'Language',
                        onEdit: node.nextFocus,
                        onSave: (val) => _language = val.trim(),
                        onValidate: (val) => val.trim().isEmpty
                            ? AppConst.FULLNAME_LENGTH_ERROR
                            : null,
                      ),
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
                          'language': _language,
                          'location': _location,
                        },
                      );
                      context.read<UserBloc>().add(UpdateUser(user: user));
                    }
                  },
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormInput extends StatelessWidget {
  const FormInput({
    Key key,
    this.title,
    this.onEdit,
    this.onSave,
    this.onValidate,
    this.isNumber = false,
  }) : super(key: key);

  final String title;
  final bool isNumber;
  final void Function() onEdit;
  final void Function(String) onSave;
  final String Function(String) onValidate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      onSaved: onSave,
      validator: onValidate,
      onEditingComplete: onEdit,
      keyboardType: isNumber ? TextInputType.number : null,
      decoration: InputDecoration(
        hintText: title,
        hintStyle: AppFonts.MEDIUM_WHITE3_16,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
