import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:covidoc/ui/screens/screens.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/ui/router.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/ui/screens/forum/components/add_question.dart';

import 'chat_request.dart';
import 'chat_screen.dart';
import 'components.dart';

class PatChatListScreen extends StatefulWidget {
  static const ROUTE_NAME = '/chat/list';

  const PatChatListScreen();

  @override
  _PatChatListScreenState createState() => _PatChatListScreenState();
}

class _PatChatListScreenState extends State<PatChatListScreen>
    with TickerProviderStateMixin {
  AppUser _user;
  bool _showAddBtn;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    // load chats
    context.read<ChatBloc>().add(LoadPatientChats());

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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conversations',
          style: AppFonts.SEMIBOLD_BLACK3_16,
        ),
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatLoadSuccess && state.conversationStarted) {
            Navigator.push(
                context,
                getRoute(ChatScreen(
                    chat: state.chatWith,
                    isFromPatient: state.userType == 'Patient')));
          }
        },
        child: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
          if (state is ChatLoadSuccess) {
            // initialize the _user
            // _user would only be used when scrolled down
            // i.e. _showAddBtn=true;  only when user state is loaded
            _user = state.user;

            if (state.requests.isNotEmpty) {
              return SingleChildScrollView(
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
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ChatRequest(user: state.user),
            );
          }
          return const Center(child: CircularProgressIndicator());
        }),
      ),
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
  final String userType;
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
              ChatItem(
                chats[index],
                userType == describeEnum(UserType.Patient),
              ),
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
