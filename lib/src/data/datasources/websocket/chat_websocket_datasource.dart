import 'dart:async';

import 'package:chatapp_ui/src/data/entities/chat_message.dart';
import 'package:chatapp_ui/src/data/entities/chat_room.dart';
import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:chatapp_ui/src/data/services/websocket_service.dart';
import 'package:injectable/injectable.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

@Singleton()
class ChatWebsocketDatasource {
  final WebsocketService websocketService;

  late StreamController<ChatMessage> _chatMessageStreamController;
  late Stream<ChatMessage> _chatMessageStream;
  late StreamController<ChatRoom> _chatRoomNotiStreamController;
  late Stream<ChatRoom> chatRoomNotiStream;

  ChatWebsocketDatasource({
    required this.websocketService,
  });

  void registerClient(User user) {
    _chatMessageStreamController = StreamController<ChatMessage>.broadcast();
    _chatMessageStream = _chatMessageStreamController.stream;
    _chatRoomNotiStreamController = StreamController<ChatRoom>.broadcast();
    chatRoomNotiStream = _chatRoomNotiStreamController.stream;
    websocketService.subscribe(
      SocketSubscription(
        destination: '/user/${user.nickName}/queue/messages',
        callback: _onChatMessageReceived,
      ),
    );
  }

  void _onChatMessageReceived(StompFrame frame) {
    final payload = frame.body;
    if (payload == null) return;
    final message = ChatMessage.fromJson(payload);
    _chatMessageStreamController.add(message);
    _chatRoomNotiStreamController.add(
      ChatRoom.buildForSelf(
        senderId: message.senderId,
        recipientId: message.recipientId,
      ),
    );
  }

  Stream<ChatMessage> getMessageStreamControllerByRecipientId(
      String recipientId) {
    final transformer =
        StreamTransformer<ChatMessage, ChatMessage>.fromHandlers(
      handleData: (data, sink) {
        if (data.senderId == recipientId) {
          sink.add(data);
        }
      },
    );

    return _chatMessageStream.transform(transformer);
  }

  void sendMessage(ChatMessage message) {
    websocketService.send(
      destination: '/app/chat',
      body: message.toJson(),
    );
    _chatMessageStreamController.add(message);
  }

  void unregisterClient() {
    _chatMessageStreamController.close();
    _chatRoomNotiStreamController.close();
  }
}
