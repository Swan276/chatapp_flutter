import 'package:chatapp_ui/src/presentation/blocs/online_users/online_users_cubit.dart';
import 'package:chatapp_ui/src/presentation/blocs/online_users/online_users_state.dart';
import 'package:chatapp_ui/src/presentation/common/ui_colors.dart';
import 'package:chatapp_ui/src/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OnlineUsersSection extends StatelessWidget {
  const OnlineUsersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(16),
      child: BlocBuilder<OnlineUsersCubit, OnlineUsersState>(
        builder: (context, state) {
          if (state.onlineUsersError != null) {
            return Center(
              child: Text(
                state.onlineUsersError!,
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }
          if (state.onlineUsers != null) {
            if (state.onlineUsers!.isEmpty) {
              return const Center(
                child: Text(
                  "Noone's online :')",
                  style: TextStyle(fontSize: 18, color: UIColors.surface40),
                ),
              );
            }
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.onlineUsers!.length,
              itemBuilder: (context, index) {
                final user = state.onlineUsers![index];
                return InkWell(
                  onTap: () {
                    RouteManager.parentNavigatorKey.currentContext!
                        .push("/chats/${user.nickName}");
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        child:
                            Text(user.fullName.characters.first.toUpperCase()),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.fullName,
                        style: const TextStyle(color: UIColors.surface20),
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 20),
            );
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
