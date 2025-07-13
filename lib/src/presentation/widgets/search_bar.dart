import 'package:chatapp_ui/src/presentation/blocs/chat_rooms/chat_rooms_cubit.dart';
import 'package:chatapp_ui/src/presentation/blocs/online_users/online_users_cubit.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late final TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    searchController.addListener(_onSearchInput);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8),
        filled: true,
        prefixIcon: const Icon(Icons.search),
        hintText: "Search",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      onSubmitted: _search,
    );
  }

  void _onSearchInput() {
    EasyDebounce.debounce('search', const Duration(milliseconds: 200), () {
      final searchKeyword = searchController.text;
      _search(searchKeyword);
    });
  }

  void _search(String keyword) {
    context.read<ChatRoomsCubit>().filterChatRooms(keyword);
    context.read<OnlineUsersCubit>().filterOnlineUsers(keyword);
  }
}
