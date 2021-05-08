import 'package:flutter/material.dart';
import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/widgets/default_button.dart';

class ReportForumModal extends StatefulWidget {
  final void Function(String report, String reporType) onSubmit;

  const ReportForumModal({
    Key key,
    this.onSubmit,
  }) : super(key: key);

  @override
  _ReportBottomSheetState createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportForumModal> {
  String _reportType = '';
  bool otherReason = false;
  String _report = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 5,
            width: 45,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: AppColors.WHITE4,
            ),
          ),
          const SizedBox(height: 20.0),
          const Center(
            child: Icon(
              Icons.report_problem_rounded,
              color: AppColors.DEFAULT,
              size: 48,
            ),
          ),
          const SizedBox(height: 10.0),
          Text('Report an issue', style: AppFonts.MEDIUM_BLACK3_16),
          const SizedBox(height: 25.0),
          AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            child: !otherReason
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      reportTile('This post contains Spam'),
                      reportTile('This post contains Nudity'),
                      reportTile('This post contains Hate Speech'),
                      reportTile('This post contains Harrasment'),
                      reportTile('Other reason', otherSelected: true),
                    ],
                  )
                : buildOtherReason(),
          )
        ],
      ),
    );
  }

  Widget buildOtherReason() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          width: screenWidth(context),
          child: Text('Report this question', style: AppFonts.MEDIUM_BLACK3_14),
        ),
        Form(
          key: _formKey,
          child: TextFormField(
            maxLines: 4,
            autofocus: true,
            onSaved: (val) => _report = val,
            validator: (val) =>
                val.trim().isEmpty ? 'Message cannot be empty' : null,
            style: AppFonts.REGULAR_BLACK3_14,
            decoration: InputDecoration(
              hintText: 'Type your Message...',
              hintStyle: AppFonts.REGULAR_WHITE3_14,
              filled: true,
              fillColor: Colors.white70,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: AppColors.WHITE3),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: AppColors.WHITE4),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: DefaultButton(
              title: 'Submit now',
              onTap: () {
                _formKey.currentState.save();
                if (_formKey.currentState.validate()) {
                  widget.onSubmit(_report, _reportType);
                }
              },
            )),
      ],
    );
  }

  bool validate(String report) {
    if (report.isEmpty) {
      return false;
    }
    return true;
  }

  Widget reportTile(String reportType, {bool otherSelected = false}) {
    return InkWell(
      onTap: () {
        if (!otherSelected) {
          widget.onSubmit('', reportType);
        } else {
          setState(() {
            _reportType = reportType;
            otherReason = otherSelected;
          });
        }
      },
      child: ListTile(
          title: Text(reportType, style: AppFonts.MEDIUM_BLACK3_14),
          trailing: const Icon(Icons.arrow_forward_ios_rounded)),
    );
  }
}
