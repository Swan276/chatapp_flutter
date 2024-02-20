import 'package:chatapp_ui/src/presentation/pages/chat_room/widgets/chat_message_widget.dart';
import 'package:chatapp_ui/src/presentation/widgets/video_call_noti_snackbar.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            const Text(
              "Playground",
              style: TextStyle(color: Colors.white),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ChatMessageWidget(
                        "Xi",
                        isSelf: false,
                        messageType: MessageType.initial,
                      ),
                      const ChatMessageWidget(
                        "Hta min srr pee p lr",
                        isSelf: false,
                        messageType: MessageType.continuing,
                      ),
                      const ChatMessageWidget(
                        "Inn",
                        isSelf: true,
                        messageType: MessageType.initial,
                      ),
                      const ChatMessageWidget(
                        "Bel shi dl",
                        isSelf: true,
                        messageType: MessageType.continuing,
                      ),
                      const ChatMessageWidget(
                        "👍",
                        isSelf: false,
                        messageType: MessageType.initial,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            VideoCallNotiSnackbar(
                              callerName: "Swan Saung",
                              onCallAccept: () {},
                              onCallReject: () {},
                            ).build(context),
                          );
                        },
                        child: const Text("Pop Up"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
