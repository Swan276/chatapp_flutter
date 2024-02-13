import 'dart:async';

import 'package:chatapp_ui/src/data/datasources/remote_datasource.dart';
import 'package:chatapp_ui/src/data/datasources/websocket/chat_websocket_datasource.dart';
import 'package:chatapp_ui/src/data/entities/chat_message.dart';
import 'package:chatapp_ui/src/data/services/memory_store_service.dart';
import 'package:chatapp_ui/src/presentation/blocs/chat/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(
    RemoteDatasource remoteDatasource,
    MemoryStoreService memoryStoreService,
    ChatWebsocketDatasource chatService, {
    required String recipientId,
  })  : _remoteDS = remoteDatasource,
        _memoryStore = memoryStoreService,
        _chatService = chatService,
        _rId = recipientId,
        super(const ChatState()) {
    uId = _loadUserId();
  }

  final RemoteDatasource _remoteDS;
  final MemoryStoreService _memoryStore;
  final ChatWebsocketDatasource _chatService;
  final String _rId;
  late final String uId;
  late final Stream<ChatMessage> _messagesStream;

  void loadChatMessages() async {
    try {
      final chatMessages = await _remoteDS.getChatMessages(uId, _rId);
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
      userId: uId,
      recipientId: _rId,
    );
    final chatMessages = _addChatMessage(message);
    emit(ChatState(chatMessages: chatMessages));
    _chatService.sendMessage(message);
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

  String _loadUserId() => _memoryStore.get('userId') ?? "";

  List<ChatMessage> _addChatMessage(ChatMessage message) {
    return [...state.chatMessages ?? <ChatMessage>[], message];
  }
}
