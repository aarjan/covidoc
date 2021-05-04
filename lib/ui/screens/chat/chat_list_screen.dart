import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:covidoc/ui/screens/screens.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/model/repo/repo.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';

import 'chat_request.dart';
import 'chat_screen.dart';
import 'components.dart';

class ChatListScreen extends StatefulWidget {
  static const ROUTE_NAME = '/chat/list';

  const ChatListScreen();

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with SingleTickerProviderStateMixin {
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
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ChatBloc(
              repo: context.read<MessageRepo>(),
            )..add(LoadChats()),
          ),
        ],
        child: BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatLoadSuccess && state.conversationStarted) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      chat: state.chatWith,
                      isFromPatient: state.userType == 'Patient',
                    ),
                  ));
            }
          },
          child: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
            if (state is ChatLoadSuccess) {
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
                            padding: const EdgeInsets.all(16),
                            child: AddQuestionView(
                              onAdd: () {
                                showBottomQuestionSheet(context);
                              },
                            ),
                          ),
                        ),
                      ),
                      _ChatListView(
                          state.chats, state.requests, state.userType),
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
      ),
      floatingActionButton: Visibility(
        visible: _showAddBtn,
        child: FloatingActionButton(
          onPressed: () {
            showBottomQuestionSheet(context);
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
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
