import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/ui/screens/forum/components/add_question.dart';

import 'components/components.dart';

class PatChatListScreen extends StatefulWidget {
  final bool? isAuthenticated;
  static const ROUTE_NAME = '/chat/list';

  const PatChatListScreen({Key? key, this.isAuthenticated}) : super(key: key);

  @override
  _PatChatListScreenState createState() => _PatChatListScreenState();
}

class _PatChatListScreenState extends State<PatChatListScreen>
    with TickerProviderStateMixin {
  AppUser? _user;
  late bool _showAddBtn;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();

    // load chats
    if (widget.isAuthenticated!)
      context.read<ChatBloc>().add(const LoadPatientChats());

    _showAddBtn = false;
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _showAddBtn = true;
        });
      }
      if (_scrollController!.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _showAddBtn = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Conversations',
          style: AppFonts.BOLD_WHITE_18,
        ),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
        if (!widget.isAuthenticated!)
          return const Padding(
            padding: EdgeInsets.all(16),
            child: ChatRequest(user: null),
          );

        if (state is ChatLoadSuccess) {
          // initialize the _user
          // _user would only be used when scrolled down
          // i.e. _showAddBtn=true;  only when user state is loaded
          _user = state.user;

          if (state.requests.isNotEmpty || state.chats.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<ChatBloc>()
                    .add(const LoadPatientChats(hardRefresh: true));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                child: Column(
                  children: [
                    AnimatedSize(
                      vsync: this,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                      child: Visibility(
                        visible: !_showAddBtn,
                        key: const ValueKey('addBtn'),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: AddQuestionView(
                            onAdd: () {
                              showBottomQuestionSheet(context, state.user);
                            },
                          ),
                        ),
                      ),
                    ),
                    _ChatListView(state.chats, state.requests, state.userType),
                  ],
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ChatRequest(user: state.user),
          );
        }
        return const Center(child: CircularProgressIndicator());
      }),
      floatingActionButton: Visibility(
        visible: _showAddBtn,
        child: FloatingActionButton(
          onPressed: () {
            showBottomQuestionSheet(context, _user);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

class _ChatListView extends StatelessWidget {
  const _ChatListView(this.chats, this.requests, this.userType);
  final String? userType;
  final List<Chat> chats;
  final List<MessageRequest> requests;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: chats.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              'Recent Chats',
              style: AppFonts.SEMIBOLD_WHITE3_14,
            ),
          ),
        ),
        // Recent Chats
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: chats.length,
          shrinkWrap: true,
          itemBuilder: (context, index) => Column(
            children: [
              ChatItem(chat: chats[index], isFromPatient: true),
              const Divider(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Text(
            'Your queries',
            style: AppFonts.SEMIBOLD_WHITE3_14,
          ),
        ),
        // Recent Queries
        ListView.separated(
          shrinkWrap: true,
          itemCount: requests.length,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) {
            return const SizedBox(height: 16);
          },
          itemBuilder: (context, index) {
            return PendingStatus(request: requests[index]);
          },
        ),
        const SizedBox(height: 32)
      ],
    );
  }
}

Future showBottomQuestionSheet(BuildContext context, AppUser? user) {
  return showModalBottomSheet(
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    enableDrag: true,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    shape: const RoundedRectangleBorder(
      side: BorderSide.none,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.75,
        expand: false,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 2,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.WHITE3,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ChatRequest(
              user: user,
            ),
          ],
        ),
      );
    },
  );
}
