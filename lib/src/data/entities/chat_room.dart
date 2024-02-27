import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:chatapp_ui/src/data/entities/chat_message.dart';

class ChatRoom extends Equatable {
  const ChatRoom({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.recipientId,
    required this.latestChatMessage,
  });

  final String id;
  final String chatId;
  final String senderId;
  final String recipientId;
  final ChatMessage latestChatMessage;

  factory ChatRoom.buildForSelf({
    required String senderId,
    required String recipientId,
    required ChatMessage latestChatMessage,
  }) {
    return ChatRoom(
      id: "",
      chatId: "${senderId}_$recipientId",
      senderId: senderId,
      recipientId: recipientId,
      latestChatMessage: latestChatMessage,
    );
  }

  ChatRoom copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? recipientId,
    ChatMessage? latestChatMessage,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      latestChatMessage: latestChatMessage ?? this.latestChatMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'recipientId': recipientId,
      'latestChatMessage': latestChatMessage.toMap(),
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] as String,
      chatId: map['chatId'] as String,
      senderId: map['senderId'] as String,
      recipientId: map['recipientId'] as String,
      latestChatMessage:
          ChatMessage.fromMap(map['latestChatMessage'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoom.fromJson(String source) =>
      ChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatRoom(id: $id, chatId: $chatId, senderId: $senderId, recipientId: $recipientId)';
  }

  @override
  List<Object> get props {
    return [
      id,
      chatId,
      senderId,
      recipientId,
      latestChatMessage,
    ];
  }

  @override
  bool get stringify => true;
}
