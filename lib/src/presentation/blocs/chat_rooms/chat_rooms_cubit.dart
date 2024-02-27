import 'package:chatapp_ui/src/data/datasources/remote_datasource.dart';
import 'package:chatapp_ui/src/data/datasources/websocket/chat_websocket_datasource.dart';
import 'package:chatapp_ui/src/data/entities/chat_room.dart';
import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:chatapp_ui/src/presentation/blocs/chat_rooms/chat_rooms_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomsCubit extends Cubit<ChatRoomsState> {
  ChatRoomsCubit(
    RemoteDatasource remoteDatasource,
    ChatWebsocketDatasource chatWebsocketDatasource,
    User currentUser,
  )   : _remoteDS = remoteDatasource,
        _chatWsDs = chatWebsocketDatasource,
        _currentUser = currentUser,
        super(const ChatRoomsState()) {
    _loadChatRooms();
  }

  final RemoteDatasource _remoteDS;
  final ChatWebsocketDatasource _chatWsDs;
  final User _currentUser;

  String? filterKeyword;

  Future<void> refresh() async {
    await _loadChatRooms();
  }

  void readNoti(String chatId) {
    var notifiedChatRooms = List<String>.from(state.notifiedChatRooms);
    notifiedChatRooms.remove(chatId);

    emit(state.copyWith(notifiedChatRooms: notifiedChatRooms));
  }

  void filterChatRooms(String keyword) {
    filterKeyword = keyword;
    if (state.chatRooms != null) {
      final filteredChatRooms = _filterWithKeyword(state.chatRooms!, keyword);
      emit(state.copyWith(filteredChatRooms: filteredChatRooms));
    }
  }

  Future<void> _loadChatRooms() async {
    try {
      final chatRooms = await _remoteDS.getChatRooms(_currentUser.username);
      _listenChatRoomNoti();
      emit(
        state.copyWith(
          chatRooms: chatRooms,
          filteredChatRooms: _filterWithKeyword(
            chatRooms,
            filterKeyword ?? "",
          ),
          chatRoomsError: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(chatRoomsError: e.toString()));
    }
  }

  void _listenChatRoomNoti() {
    _chatWsDs.chatRoomNotiStream.listen((chatRoom) {
      final (chatRooms, notifiedChatRooms) = _updateChatRoom(chatRoom);
      final filteredChatRooms =
          _filterWithKeyword(chatRooms, filterKeyword ?? "");

      emit(
        state.copyWith(
          chatRooms: chatRooms,
          filteredChatRooms: filteredChatRooms,
          notifiedChatRooms: notifiedChatRooms,
        ),
      );
    });
  }

  (List<ChatRoom>, List<String>) _updateChatRoom(ChatRoom chatRoom) {
    if (state.chatRooms == null || state.chatRooms!.isEmpty) {
      return ([chatRoom], [chatRoom.chatId]);
    }

    var notifiedChatRooms = List<String>.from(state.notifiedChatRooms);
    notifiedChatRooms.remove(chatRoom.chatId);
    notifiedChatRooms.insert(0, chatRoom.chatId);

    var chatRooms = List<ChatRoom>.from(state.chatRooms!);
    chatRooms.removeWhere((cRoom) => chatRoom.chatId == cRoom.chatId);
    chatRooms.insert(0, chatRoom);

    return (chatRooms, notifiedChatRooms);
  }

  List<ChatRoom> _filterWithKeyword(List<ChatRoom> chatRooms, String keyword) {
    if (keyword.isEmpty) return chatRooms;
    return chatRooms
        .where(
          (chatRoom) => chatRoom.recipientId.contains(keyword),
        )
        .toList();
  }
}
