import 'package:chatapp_ui/src/presentation/common/ui_colors.dart';
import 'package:flutter/material.dart';

class VideoCallNotiSnackbar {
  const VideoCallNotiSnackbar({
    required this.callerName,
    required this.onCallAccept,
    required this.onCallReject,
  });

  final String callerName;
  final VoidCallback onCallAccept;
  final VoidCallback onCallReject;

  SnackBar build(BuildContext context) {
    return SnackBar(
      content: _NotiSnackbarContent(
        callerName: callerName,
        onCallReject: onCallReject,
        onCallAccept: onCallAccept,
      ),
      backgroundColor: UIColors.secondarySurface,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height -
            MediaQuery.of(context).viewInsets.top -
            MediaQuery.of(context).padding.top -
            200,
        left: 20,
        right: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
    );
  }
}

class _NotiSnackbarContent extends StatelessWidget {
  const _NotiSnackbarContent({
    required this.callerName,
    required this.onCallReject,
    required this.onCallAccept,
  });

  final String callerName;
  final VoidCallback onCallReject;
  final VoidCallback onCallAccept;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          child: Text(callerName.characters.first.toUpperCase()),
        ),
        const SizedBox(width: 8),
        Text(
          callerName,
          style: const TextStyle(fontSize: 18),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: 8),
        const Spacer(),
        IconButton.filled(
          onPressed: onCallReject,
          icon: const Icon(Icons.close),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.red,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: onCallAccept,
          icon: const Icon(Icons.check),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              UIColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
