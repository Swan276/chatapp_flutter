import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:chatapp_ui/src/presentation/blocs/auth/auth_cubit.dart';
import 'package:chatapp_ui/src/presentation/common/ui_colors.dart';
import 'package:chatapp_ui/src/presentation/pages/profile/widgets/logout_button.dart';
import 'package:chatapp_ui/src/presentation/pages/profile/widgets/profile_appbar.dart';
import 'package:chatapp_ui/src/presentation/pages/profile/widgets/profile_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final User user;

  @override
  void initState() {
    user = context.read<AuthCubit>().getCurrentUser()!;
    super.initState();
  }

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
