import 'dart:convert';

import 'package:equatable/equatable.dart';

class ChatRoom extends Equatable {
  const ChatRoom({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.recipientId,
  });

  final String id;
  final String chatId;
  final String senderId;
  final String recipientId;

  factory ChatRoom.buildForSelf({
    required String senderId,
    required String recipientId,
  }) {
    return ChatRoom(
      id: "",
      chatId: "${senderId}_$recipientId",
      senderId: recipientId,
      recipientId: senderId,
    );
  }

  ChatRoom copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? recipientId,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'recipientId': recipientId,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] as String,
      chatId: map['chatId'] as String,
      senderId: map['senderId'] as String,
      recipientId: map['recipientId'] as String,
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
  List<Object?> get props => [id, chatId, senderId, recipientId];
}
