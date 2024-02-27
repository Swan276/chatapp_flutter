import 'package:chatapp_ui/src/presentation/blocs/auth/auth_cubit.dart';
import 'package:chatapp_ui/src/presentation/common/ui_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Logout"),
              titleTextStyle: const TextStyle(
                color: UIColors.surface20,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              content: const Text("Are you sure you want to logout?"),
              contentTextStyle: const TextStyle(
                color: UIColors.surface20,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              actionsPadding: const EdgeInsets.all(16),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                  },
                  child: const Text("Confirm"),
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 48,
          vertical: 12,
        ),
        elevation: 3,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.logout),
          SizedBox(width: 8),
          Text(
            "Logout",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
