// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:chatapp_ui/src/data/entities/chat_room.dart';

class ChatRoomsState {
  final List<ChatRoom>? chatRooms;
  final List<String> notifiedChatRooms;
  final String? chatRoomsError;

  ChatRoomsState({
    this.chatRooms,
    this.notifiedChatRooms = const [],
    this.chatRoomsError,
  });

  ChatRoomsState copyWith({
    List<ChatRoom>? chatRooms,
    List<String>? notifiedChatRooms,
    String? chatRoomsError,
  }) {
    return ChatRoomsState(
      chatRooms: chatRooms ?? this.chatRooms,
      notifiedChatRooms: notifiedChatRooms ?? this.notifiedChatRooms,
      chatRoomsError: chatRoomsError ?? this.chatRoomsError,
    );
  }

  @override
  bool operator ==(covariant ChatRoomsState other) {
    if (identical(this, other)) return true;

    return listEquals(other.chatRooms, chatRooms) &&
        listEquals(other.notifiedChatRooms, notifiedChatRooms) &&
        other.chatRoomsError == chatRoomsError;
  }

  @override
  int get hashCode {
    return chatRooms.hashCode ^
        notifiedChatRooms.hashCode ^
        chatRoomsError.hashCode;
  }

  @override
  String toString() {
    return 'ChatRoomsState(chatRooms: $chatRooms, notifiedChatRooms: $notifiedChatRooms, chatRoomsError: $chatRoomsError)';
  }
}
