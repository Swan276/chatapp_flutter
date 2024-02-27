import 'dart:async';

import 'package:chatapp_ui/src/data/datasources/remote_datasource.dart';
import 'package:chatapp_ui/src/data/datasources/websocket/chat_websocket_datasource.dart';
import 'package:chatapp_ui/src/data/entities/chat_message.dart';
import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:chatapp_ui/src/presentation/blocs/chat/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(
    RemoteDatasource remoteDatasource,
    ChatWebsocketDatasource chatService, {
    required this.user,
    required String recipientId,
  })  : _remoteDS = remoteDatasource,
        _chatService = chatService,
        _rId = recipientId,
        super(const ChatState());

  final RemoteDatasource _remoteDS;
  final ChatWebsocketDatasource _chatService;
  final String _rId;
  final User user;
  late final Stream<ChatMessage> _messagesStream;

  void loadChatMessages() async {
    try {
      final chatMessages = await _remoteDS.getChatMessages(user.username, _rId);
      _listenLiveChatMessage();
      emit(state.copyWith(chatMessages: chatMessages, chatMessageError: null));
    } catch (e) {
      emit(state.copyWith(chatMessageError: e.toString()));
    }
  }

  void sendMessage(String content) {
    content = content.trim();
    if (content.isEmpty) return;
    final message = ChatMessage.build(
      content: content,
      userId: user.username,
      recipientId: _rId,
    );
    _chatService.sendMessage(message);
    final chatMessages = _addChatMessage(message);
    emit(ChatState(chatMessages: chatMessages));
  }

  void _listenLiveChatMessage() {
    _messagesStream =
        _chatService.getMessageStreamControllerByRecipientId(_rId);
    _messagesStream.listen(
      (message) {
        final chatMessages = _addChatMessage(message);
        emit(ChatState(chatMessages: chatMessages));
      },
    );
  }

  List<ChatMessage> _addChatMessage(ChatMessage message) {
    var chatMessages = List<ChatMessage>.from(state.chatMessages ?? []);
    return chatMessages..insert(0, message);
  }
}
