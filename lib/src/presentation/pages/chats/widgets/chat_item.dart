import 'package:chatapp_ui/src/presentation/common/ui_colors.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.name,
    required this.isNotified,
    required this.onTap,
  });

  final String name;
  final bool isNotified;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final faker = Faker();
    final messageList = faker.lorem.sentences(2);
    final messages = messageList.reduce((value, element) => "$value $element");

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 84,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: CircleAvatar(radius: 28)),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: UIColors.surface20,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        messages,
                        style: const TextStyle(
                          color: UIColors.surface60,
                          fontSize: 14,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
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
                  const Text(
                    "4:30 PM",
                    style: TextStyle(
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
}
