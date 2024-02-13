import 'package:equatable/equatable.dart';

import 'package:chatapp_ui/src/data/entities/chat_message.dart';

class ChatState extends Equatable {
  const ChatState({
    this.chatMessages,
    this.chatMessageError,
  });

  final List<ChatMessage>? chatMessages;
  final String? chatMessageError;

  ChatState copyWith({
    List<ChatMessage>? chatMessages,
    String? chatMessageError,
  }) {
    return ChatState(
      chatMessages: chatMessages ?? this.chatMessages,
      chatMessageError: chatMessageError ?? this.chatMessageError,
    );
  }

  @override
  String toString() =>
      'ChatState(chatMessages: $chatMessages, chatMessageError: $chatMessageError)';

  @override
  List<Object?> get props => [chatMessages, chatMessageError];
}
