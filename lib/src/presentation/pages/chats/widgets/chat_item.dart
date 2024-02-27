import 'package:chatapp_ui/src/data/entities/chat_room.dart';
import 'package:chatapp_ui/src/presentation/common/ui_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.chatRoom,
    required this.isNotified,
    required this.onTap,
  });

  final ChatRoom chatRoom;
  final bool isNotified;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 28,
                child: Text(
                  chatRoom.recipientId.characters.first.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatRoom.recipientId,
                      style: const TextStyle(
                        color: UIColors.surface20,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          chatRoom.latestChatMessage.content,
                          style: const TextStyle(
                            color: UIColors.surface60,
                            fontSize: 14,
                            height: 1.4,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatDateTime(chatRoom.latestChatMessage.timestamp),
                    style: const TextStyle(
                      color: UIColors.surface60,
                      fontSize: 12,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  isNotified
                      ? Container(
                          height: 22,
                          width: 22,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF1B72C0),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    final now = DateTime.now();
    if (dateTime == null || _aboutTheSameTime(now, dateTime)) {
      return "now";
    }

    if (_isSameDay(now, dateTime)) {
      return DateFormat('hh:mm a').format(dateTime);
    }

    if (_isSameWeek(now, dateTime)) {
      return DateFormat.E().format(dateTime);
    }

    if (_isSameYear(now, dateTime)) {
      return DateFormat.MMMd().format(dateTime);
    } else {
      return DateFormat.yMMMMd({super.key}).format(dateTime);
    }
  }

  bool _aboutTheSameTime(DateTime current, DateTime timestamp) {
    return current.subtract(const Duration(minutes: 5)).compareTo(timestamp) <=
        0;
  }

  bool _isSameDay(DateTime current, DateTime timestamp) {
    return current.subtract(const Duration(days: 1)).compareTo(timestamp) <= 0;
  }

  bool _isSameWeek(DateTime current, DateTime timestamp) {
    return current.subtract(const Duration(days: 7)).compareTo(timestamp) <= 0;
  }

  bool _isSameYear(DateTime current, DateTime timestamp) {
    return current.year == timestamp.year;
  }
}
