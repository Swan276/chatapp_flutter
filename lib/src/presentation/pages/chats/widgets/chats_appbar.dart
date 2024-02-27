import 'package:chatapp_ui/src/presentation/common/ui_colors.dart';
import 'package:chatapp_ui/src/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class ChatsAppbar extends StatelessWidget {
  const ChatsAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Chats",
              style: TextStyle(
                fontSize: 32,
                color: UIColors.surface20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          CustomSearchBar(),
        ],
      ),
    );
  }
}
