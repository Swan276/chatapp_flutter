import 'dart:convert';

import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String? id;
  final String? chatId;
  final String senderId;
  final String recipientId;
  final String content;
  final DateTime? timestamp;

  const ChatMessage({
    this.id,
    this.chatId,
    required this.senderId,
    required this.recipientId,
    required this.content,
    this.timestamp,
  });

  factory ChatMessage.build({
    required String content,
    required String userId,
    required String recipientId,
  }) {
    return ChatMessage(
      senderId: userId,
      recipientId: recipientId,
      content: content,
      timestamp: DateTime.now(),
    );
  }

  ChatMessage copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? recipientId,
    String? content,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'recipientId': recipientId,
      'content': content,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String,
      chatId: map['chatId'] as String?,
      senderId: map['senderId'] as String,
      recipientId: map['recipientId'] as String,
      content: map['content'] as String,
      timestamp: DateTime.tryParse(
            map['timestamp']?.toString() ??
                DateTime.now().toUtc().toIso8601String(),
          )?.toLocal() ??
          DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatMessage(id: $id, chatId: $chatId, senderId: $senderId, recipientId: $recipientId, content: $content, timestamp: $timestamp)';
  }

  @override
  List<Object?> get props =>
      [id, chatId, senderId, recipientId, content, timestamp];
}
