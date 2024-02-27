import 'package:chatapp_ui/src/presentation/blocs/chat_rooms/chat_rooms_cubit.dart';
import 'package:chatapp_ui/src/presentation/blocs/chat_rooms/chat_rooms_state.dart';
import 'package:chatapp_ui/src/presentation/common/ui_colors.dart';
import 'package:chatapp_ui/src/presentation/pages/chats/widgets/chat_item.dart';
import 'package:chatapp_ui/src/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatsListSection extends StatelessWidget {
  const ChatsListSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomsCubit, ChatRoomsState>(
      builder: (context, state) {
        if (state.chatRoomsError != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                state.chatRoomsError!,
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          );
        }
        if (state.chatRooms != null) {
          if (state.chatRooms!.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "No Chat Messages",
                  style: TextStyle(fontSize: 18, color: UIColors.surface40),
                ),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.chatRooms!.length,
            itemBuilder: (context, index) {
              final chatRoom = state.chatRooms![index];
              return ChatItem(
                name: chatRoom.recipientId,
                isNotified: state.notifiedChatRooms.contains(chatRoom.chatId),
                onTap: () {
                  context.read<ChatRoomsCubit>().readNoti(chatRoom.chatId);
                  RouteManager.parentNavigatorKey.currentContext!
                      .push("/chats/${chatRoom.recipientId}");
                },
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator.adaptive(
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }
}
