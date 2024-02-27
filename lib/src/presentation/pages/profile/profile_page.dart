import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:chatapp_ui/src/presentation/common/ui_colors.dart';
import 'package:chatapp_ui/src/presentation/pages/profile/widgets/logout_button.dart';
import 'package:chatapp_ui/src/presentation/pages/profile/widgets/profile_appbar.dart';
import 'package:chatapp_ui/src/presentation/pages/profile/widgets/profile_info.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ProfileAppbar(),
            const Spacer(),
            ProfileInfo(user: user),
            const SizedBox(height: 48),
            const LogoutButton(),
            const SizedBox(height: 48),
            const Spacer(),
            const Text(
              "Chat App 1.0.0",
              style: TextStyle(
                color: UIColors.surface60,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
