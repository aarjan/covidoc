import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/screens/screens.dart';

import 'components/components.dart';

class ForumScreen extends StatefulWidget {
  static const ROUTE_NAME = '/forum';

  const ForumScreen();

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen>
    with TickerProviderStateMixin {
  bool _showAddBtn;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _showAddBtn = false;
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _showAddBtn = true;
        });
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _showAddBtn = false;
        });
      }
    });

    context.read<ForumBloc>().add(LoadForum());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discuss', style: AppFonts.SEMIBOLD_BLACK3_16),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: BlocBuilder<ForumBloc, ForumState>(builder: (context, state) {
        if (state is ForumLoadSuccess) {
          return SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  AnimatedSize(
                    vsync: this,
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 400),
                    child: Visibility(
                      visible: !_showAddBtn,
                      child: AddQuestionView(
                        onAdd: () {
                          showAddQuestionModal(context);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Filters(),
                  ListView.builder(
                    itemCount: state.forums.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return QuestionItem(
                        question: state.forums[index],
                        onTap: () {
                          context
                              .read<AnswerBloc>()
                              .add(LoadAnswers(state.forums[index]));

                          Navigator.pushNamed(
                              context, ForumDiscussScreen.ROUTE_NAME);
                        },
                      );
                    },
                  ),
                ],
              ));
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
      floatingActionButton: Visibility(
        visible: _showAddBtn,
        child: FloatingActionButton(
          onPressed: () async {
            return showAddQuestionModal(context);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> showAddQuestionModal(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return const AddUpdateQuestionModal();
        });
  }
}
