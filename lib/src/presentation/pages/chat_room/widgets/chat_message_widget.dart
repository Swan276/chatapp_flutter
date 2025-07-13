import 'package:chatapp_ui/src/presentation/common/ui_colors.dart';
import 'package:flutter/material.dart';

enum MessageType { initial, continuing }

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget(
    this.text, {
    super.key,
    this.isSelf = true,
    this.messageType = MessageType.initial,
  });

  final String text;
  final bool isSelf;
  final MessageType messageType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _getMargin(),
      child: Row(
        mainAxisAlignment:
            isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _getPrefix(),
              isSelf ? const SizedBox(width: 8) : const SizedBox.shrink(),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getMessageColor(),
              borderRadius: _getBorderRadius(),
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPrefix() {
    if (isSelf) return const SizedBox.shrink();

    // show image if the user has image
    // show person icon if the user doesn't have image
    String? imageUrl;
    // if (hasImage) {
    //   imageUrl = faker.image.image();
    // }
    // ---

    return Row(
      children: [
        messageType == MessageType.initial
            ? CircleAvatar(
                radius: 20,
                child: _getUserAvatar(imageUrl),
              )
            : const SizedBox(width: 40),
        const SizedBox(width: 6),
      ],
    );
  }

  Widget _getUserAvatar(String? imageUrl) {
    if (imageUrl != null) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          shape: BoxShape.circle,
        ),
      );
    } else {
      return const Icon(
        Icons.person,
        color: UIColors.surface60,
      );
    }
  }

  Color _getMessageColor() {
    return isSelf ? UIColors.primaryContainer : UIColors.secondarySurface;
  }

  BorderRadiusGeometry _getBorderRadius() {
    switch (messageType) {
      case MessageType.initial:
        if (isSelf) {
          return _selfInitialBorder;
        } else {
          return _otherInitialBorder;
        }
      default:
        return _continuingBorder;
    }
  }

  EdgeInsetsGeometry _getMargin() {
    switch (messageType) {
      case MessageType.initial:
        return const EdgeInsets.only(top: 8);
      default:
        return const EdgeInsets.only(top: 4);
    }
  }

  final BorderRadiusGeometry _continuingBorder =
      const BorderRadius.all(_radiusFull);
  final BorderRadiusGeometry _selfInitialBorder = const BorderRadius.only(
    topLeft: _radiusFull,
    topRight: _radiusZero,
    bottomLeft: _radiusFull,
    bottomRight: _radiusFull,
  );
  final BorderRadiusGeometry _otherInitialBorder = const BorderRadius.only(
    topLeft: _radiusZero,
    topRight: _radiusFull,
    bottomLeft: _radiusFull,
    bottomRight: _radiusFull,
  );

  static const Radius _radiusFull = Radius.circular(16);
  static const Radius _radiusZero = Radius.zero;
}
