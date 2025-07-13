import 'package:chatapp_ui/src/presentation/common/ui_colors.dart';
import 'package:flutter/material.dart';

class ProfileAppbar extends StatelessWidget {
  const ProfileAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Profile",
        style: TextStyle(
          fontSize: 32,
          color: UIColors.surface20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
