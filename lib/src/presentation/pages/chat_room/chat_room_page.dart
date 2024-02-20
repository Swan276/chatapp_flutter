import 'package:chatapp_ui/src/data/entities/chat_message.dart';
import 'package:chatapp_ui/src/presentation/blocs/chat/chat_cubit.dart';
import 'package:chatapp_ui/src/presentation/blocs/chat/chat_state.dart';
import 'package:chatapp_ui/src/presentation/common/ui_colors.dart';
import 'package:chatapp_ui/src/presentation/pages/chat_room/widgets/chat_message_widget.dart';
import 'package:chatapp_ui/src/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({super.key, required this.recipientId});

  final String recipientId;

  @override
  Widget build(BuildContext context) {
    return _ChatRoomPageContent(recipientId: recipientId);
  }
}

class _ChatRoomPageContent extends StatefulWidget {
  const _ChatRoomPageContent({required this.recipientId});

  final String recipientId;

  @override
  State<_ChatRoomPageContent> createState() => __ChatRoomPageContentState();
}

class __ChatRoomPageContentState extends State<_ChatRoomPageContent> {
  late final String name;
  late final TextEditingController messageInputController;
  late final FocusNode messageInputFocusNode;
  late final ScrollController chatScrollController;
  late final KeyboardVisibilityController keyboardVisibilityController;

  @override
  void initState() {
    context.read<ChatCubit>().loadChatMessages();
    name = widget.recipientId;
    messageInputController = TextEditingController();
    messageInputFocusNode = FocusNode();
    chatScrollController = ScrollController();
    keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((event) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: UIColors.background,
        foregroundColor: Colors.white,
        leading: const BackButton(),
        title: Text(name),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              RouteManager.parentNavigatorKey.currentContext!.push(
                "/videoCall/${widget.recipientId}",
              );
            },
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {
              RouteManager.parentNavigatorKey.currentContext!.push(
                "/videoCall/${widget.recipientId}",
              );
            },
            icon: const Icon(Icons.videocam),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: messageInputFocusNode.unfocus,
                  child: BlocConsumer<ChatCubit, ChatState>(
                    listener: (context, state) {
                      if (state.chatMessages != null) {
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => _scrollToBottom());
                      }
                    },
                    builder: (context, state) {
                      if (state.chatMessageError != null) {
                        return Center(
                          child: Text(
                            state.chatMessageError!,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.red),
                          ),
                        );
                      }
                      if (state.chatMessages != null) {
                        if (state.chatMessages!.isEmpty) {
                          return const Center(
                            child: Text(
                              "No Messages",
                              style: TextStyle(
                                  fontSize: 18, color: UIColors.surface40),
                            ),
                          );
                        }
                        final List<ChatMessage> chatMessageList =
                            state.chatMessages!;
                        return Align(
                          alignment: Alignment.topCenter,
                          child: ListView.builder(
                            controller: chatScrollController,
                            itemCount: chatMessageList.length,
                            itemBuilder: (context, index) {
                              final message = chatMessageList[index];

                              return ChatMessageWidget(
                                message.content,
                                isSelf: message.senderId ==
                                    context.read<ChatCubit>().uId,
                              );
                            },
                            reverse: true,
                            shrinkWrap: true,
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(
                            backgroundColor: Colors.white,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 50,
                      ),
                      child: TextField(
                        controller: messageInputController,
                        focusNode: messageInputFocusNode,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          hintText: "Say Something ...",
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        maxLines: null,
                        expands: true,
                        onSubmitted: (value) {
                          context.read<ChatCubit>().sendMessage(value);
                          messageInputController.clear();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  IconButton(
                    onPressed: () {
                      if (messageInputController.text.isNotEmpty) {
                        context
                            .read<ChatCubit>()
                            .sendMessage(messageInputController.text);
                        messageInputController.clear();
                        _scrollToBottom();
                      }
                    },
                    icon: const Icon(Icons.send),
                    color: UIColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToBottom() {
    chatScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
