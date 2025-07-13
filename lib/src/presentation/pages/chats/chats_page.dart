import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:chatapp_ui/src/di.dart';
import 'package:chatapp_ui/src/presentation/blocs/auth/auth_cubit.dart';
import 'package:chatapp_ui/src/presentation/blocs/chat_rooms/chat_rooms_cubit.dart';
import 'package:chatapp_ui/src/presentation/blocs/online_users/online_users_cubit.dart';
import 'package:chatapp_ui/src/presentation/pages/chats/widgets/chats_appbar.dart';
import 'package:chatapp_ui/src/presentation/pages/chats/widgets/chats_list_section.dart';
import 'package:chatapp_ui/src/presentation/pages/chats/widgets/online_users_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late final User? user;

  @override
  void initState() {
    user = context.read<AuthCubit>().getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatRoomsCubit>(
          create: (context) => ChatRoomsCubit(
            di.get(),
            di.get(),
            user!,
          ),
        ),
        BlocProvider(
          create: (context) => OnlineUsersCubit(
            di.get(),
            di.get(),
            user!,
          ),
        ),
      ],
      child: const _ChatsPage(),
    );
  }
}

class _ChatsPage extends StatelessWidget {
  const _ChatsPage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ChatsAppbar(),
        Expanded(
          child: RefreshIndicator.adaptive(
            onRefresh: () async {
              context.read<OnlineUsersCubit>().refresh();
              context.read<ChatRoomsCubit>().refresh();
            },
            child: const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  OnlineUsersSection(),
                  ChatsListSection(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
