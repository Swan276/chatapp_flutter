import 'package:chatapp_ui/src/presentation/pages/chat_room/widgets/chat_message_widget.dart';
import 'package:flutter/material.dart';

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Playground",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChatMessageWidget(
                "Xi",
                isSelf: false,
                messageType: MessageType.initial,
              ),
              ChatMessageWidget(
                "Hta min srr pee p lr",
                isSelf: false,
                messageType: MessageType.continuing,
              ),
              ChatMessageWidget(
                "Inn",
                isSelf: true,
                messageType: MessageType.initial,
              ),
              ChatMessageWidget(
                "Bel shi dl",
                isSelf: true,
                messageType: MessageType.continuing,
              ),
              ChatMessageWidget(
                "👍",
                isSelf: false,
                messageType: MessageType.initial,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
