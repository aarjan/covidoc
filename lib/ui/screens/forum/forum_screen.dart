import 'package:covidoc/ui/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/screens/screens.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/ui/widgets/dropdown_filter.dart';

import 'components/components.dart';

class ForumScreen extends StatefulWidget {
  static const ROUTE_NAME = '/forum';

  final bool isAuthenticated;

  const ForumScreen({Key? key, this.isAuthenticated = false}) : super(key: key);

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  List<Forum>? _forums;
  late bool _showAddBtn;
  String _category = 'All';
  bool _isLoading = false;
  late ScrollController _scrollController;
  final _categories = ['All', 'Category1', 'Category2', 'Category3'];

  @override
  void initState() {
    super.initState();
    _showAddBtn = false;

    // ------------------------------------------------------------------------
    // SCROLLCONTROLLER IS USED TO SHOW/HIDE FAB ICON & ADDQUESTION CONTAINER
    // IF SCROLLDIRECTION IS REVERSE (SCROLL DOWN) FAB ICON IS DISPLAYED
    // IF SCROLLDIRECTION IS FORWARD (SCROLL UP) ADDQUESTION IS DISPLAYED
    // ------------------------------------------------------------------------
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final _direction = _scrollController.position.userScrollDirection;

      if (_direction == ScrollDirection.reverse && !_showAddBtn) {
        setState(() {
          _showAddBtn = true;
        });
      }
      if (_direction == ScrollDirection.forward && _showAddBtn) {
        setState(() {
          _showAddBtn = false;
        });
      }

      // ----------------------------------------------------------------------
      // FETCH MORE ITEMS WHEN REACHED THE BOTTOM (90%) OF THE SCREEN
      // ----------------------------------------------------------------------
      final maxExtent = _scrollController.position.maxScrollExtent * 0.9;
      if (_scrollController.position.pixels > maxExtent &&
          !_isLoading &&
          _direction == ScrollDirection.reverse) {
        _isLoading = true;
        context.read<ForumBloc>().add(LoadForum(loadMore: true));
      }
    });

    context.read<ForumBloc>().add(LoadForum());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Discuss',
          style: AppFonts.BOLD_WHITE_18,
        ),
      ),
      body: BlocConsumer<ForumBloc, ForumState>(listener: (context, state) {
        if (state is ForumLoadSuccess && state.msg != null) {
          context.toast(state.msg!, seconds: 4);
        }
      }, builder: (context, state) {
        if (state is ForumLoadSuccess) {
          _isLoading = false;
          _forums = state.forums;
        }
        return Stack(
          children: [
            // --------------------------------------------------------
            // REFRESH INDICATOR FOR PULL TO REFRESH
            // --------------------------------------------------------
            RefreshIndicator(
              onRefresh: () async {
                context.read<ForumBloc>().add(LoadForum(hardRefresh: true));
              },
              child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      // ------------------------------------------------------
                      // ADDQUESTION WIDGET FOR ADDING NEW QUESTION
                      // VISIBIBLE IF _showAddBtn == false
                      // ------------------------------------------------------
                      Visibility(
                        visible: !_showAddBtn,
                        child: AddQuestionView(
                          onAdd: () {
                            showAddQuestionModal(
                                context, widget.isAuthenticated);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // ------------------------------------------------------
                      // DROPDOWN FILTERS
                      // Category & Sort Dropdown
                      // ------------------------------------------------------
                      Row(
                        children: [
                          Flexible(
                            child: DropdownFilter(
                              title: 'Category',
                              fillColor: AppColors.WHITE4,
                              items: _categories,
                              selectedCategory: _category,
                              onItemSelected: (val) {
                                _category = val;
                                setState(() {});
                                context.read<ForumBloc>().add(
                                      LoadForum(
                                        category: val,
                                        hardRefresh: true,
                                      ),
                                    );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: DropdownFilter(
                              title: 'Sort',
                              fillColor: AppColors.WHITE4,
                              items: ['Sort1', 'Sort2', 'Sort3'],
                              onItemSelected: (val) {},
                            ),
                          ),
                        ],
                      ),
                      // ------------------------------------------------------
                      // LISTVIEW FOR THE FORUM QUESTIONS
                      // ------------------------------------------------------
                      if (_forums != null)
                        ListView.builder(
                          itemCount: _forums!.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return QuestionItem(
                              key: ValueKey(_forums![index].id),
                              question: _forums![index],
                              onTap: () {
                                context.read<AnswerBloc>().add(
                                    LoadAnswers(question: _forums![index]));

                                Navigator.push(
                                    context,
                                    getRoute(ForumDiscussScreen(
                                      isAuthenticated: widget.isAuthenticated,
                                    )));
                              },
                            );
                          },
                        ),
                    ],
                  )),
            ),
            // ----------------------------------------------------------------
            // CIRCULARPROGRESSINDICATOR IS DISPLAYED
            // WHEN STATE IS FORUMLOADINPROGRESS
            // ----------------------------------------------------------------
            if (state is ForumLoadInProgress)
              const Center(child: CircularProgressIndicator())
          ],
        );
      }),
      // ----------------------------------------------------------------------
      // FAB BUTTON FOR ADDING QUESTION
      // VISIBIBLE IF _showAddBtn == true
      // ----------------------------------------------------------------------
      floatingActionButton: Visibility(
        visible: _showAddBtn,
        child: FloatingActionButton(
          onPressed: () async {
            return showAddQuestionModal(context, widget.isAuthenticated);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> showAddQuestionModal(
      BuildContext context, bool isAuthenticated) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return AddUpdateQuestionModal(
            onSubmit: (question, tags, category, images) async {
              if (!isAuthenticated) {
                return showLoginDialog(context);
              }

              final forum = Forum(
                tags: tags,
                title: question,
                category: category,
              );

              context.read<ForumBloc>().add(AddForum(forum, images));
            },
          );
        });
  }
}
