import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/screens/screens.dart';
import 'package:covidoc/ui/widgets/widgets.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/bloc/user/user_bloc.dart';

class PatientDescScreen extends StatelessWidget {
  static const ROUTE_NAME = '/register/description';

  const PatientDescScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoadSuccess) {
          Navigator.pushNamed(context, CovidStatusScreen.ROUTE_NAME);
        }
      },
      child: const PatientDescription(),
    );
  }
}

class PatientDescription extends StatefulWidget {
  const PatientDescription({Key? key}) : super(key: key);

  @override
  _PatientDescriptionState createState() => _PatientDescriptionState();
}

class _PatientDescriptionState extends State<PatientDescription> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _age;
  String? _name;
  String? _gender;
  String? _location;
  String? _language;

  late FocusScopeNode _node;

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Describe Yourself', style: AppFonts.SEMIBOLD_BLACK3_16),
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 2),
          child: Row(
            children: [AppColors.DEFAULT, AppColors.WHITE3, AppColors.WHITE3]
                .map((e) => Flexible(
                    child:
                        Container(color: e, width: double.infinity, height: 2)))
                .toList(),
          ),
        ),
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
                        onEdit: _node.nextFocus,
                        onSave: (val) => _name = val!.trim(),
                        onValidate: (val) => val!.trim().isEmpty
                            ? AppConst.FULLNAME_LENGTH_ERROR
                            : null,
                      ),
                      const SizedBox(height: 16),
                      FormInput(
                        title: 'Age',
                        isNumber: true,
                        onEdit: _node.nextFocus,
                        onSave: (val) =>
                            _age = int.tryParse(val!.trim(), radix: 10),
                        onValidate: (val) =>
                            val!.trim().isEmpty ? AppConst.AGE_ERROR : null,
                      ),
                      const SizedBox(height: 16),
                      FormInput(
                        title: 'Gender',
                        onEdit: _node.nextFocus,
                        onSave: (val) => _gender = val!.trim(),
                        onValidate: (val) =>
                            val!.trim().isEmpty ? AppConst.GENDER_ERROR : null,
                      ),
                      const SizedBox(height: 16),
                      FormInput(
                        title: 'Location',
                        onEdit: _node.nextFocus,
                        onSave: (val) => _location = val!.trim(),
                        onValidate: (val) => val!.trim().isEmpty
                            ? AppConst.LOCATION_ERROR
                            : null,
                      ),
                      const SizedBox(height: 16),
                      FormInput(
                        title: 'Language',
                        onEdit: _node.nextFocus,
                        onSave: (val) => _language = val!.trim(),
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
                    _formKey.currentState!.save();
                    FocusScope.of(context).unfocus();

                    if (_formKey.currentState!.validate()) {
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
