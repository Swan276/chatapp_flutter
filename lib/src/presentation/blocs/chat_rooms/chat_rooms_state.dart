import 'package:equatable/equatable.dart';

import 'package:chatapp_ui/src/data/entities/chat_room.dart';

class ChatRoomsState extends Equatable {
  final List<ChatRoom>? chatRooms;
  final List<ChatRoom>? filteredChatRooms;
  final List<String> notifiedChatRooms;
  final String? chatRoomsError;

  const ChatRoomsState({
    this.chatRooms,
    this.filteredChatRooms,
    this.notifiedChatRooms = const [],
    this.chatRoomsError,
  });

  ChatRoomsState copyWith({
    List<ChatRoom>? chatRooms,
    List<ChatRoom>? filteredChatRooms,
    List<String>? notifiedChatRooms,
    String? chatRoomsError,
  }) {
    return ChatRoomsState(
      chatRooms: chatRooms ?? this.chatRooms,
      filteredChatRooms: filteredChatRooms ?? this.filteredChatRooms,
      notifiedChatRooms: notifiedChatRooms ?? this.notifiedChatRooms,
      chatRoomsError: chatRoomsError ?? this.chatRoomsError,
    );
  }

  @override
  String toString() {
    return 'ChatRoomsState(chatRooms: $chatRooms, notifiedChatRooms: $notifiedChatRooms, chatRoomsError: $chatRoomsError)';
  }

  @override
  List<Object?> get props => [
        chatRooms,
        filteredChatRooms,
        notifiedChatRooms,
        chatRoomsError,
      ];

  @override
  bool get stringify => true;
}
