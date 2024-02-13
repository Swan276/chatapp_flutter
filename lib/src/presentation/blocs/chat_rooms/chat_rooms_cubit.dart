import 'package:chatapp_ui/src/data/datasources/remote_datasource.dart';
import 'package:chatapp_ui/src/data/datasources/websocket/chat_websocket_datasource.dart';
import 'package:chatapp_ui/src/data/entities/chat_room.dart';
import 'package:chatapp_ui/src/data/services/memory_store_service.dart';
import 'package:chatapp_ui/src/presentation/blocs/chat_rooms/chat_rooms_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class ChatRoomsCubit extends Cubit<ChatRoomsState> {
  ChatRoomsCubit(
    RemoteDatasource remoteDatasource,
    MemoryStoreService memoryStoreService,
    ChatWebsocketDatasource chatWebsocketDatasource,
  )   : _remoteDS = remoteDatasource,
        _memoryStore = memoryStoreService,
        _chatWsDs = chatWebsocketDatasource,
        super(ChatRoomsState()) {
    _uId = _loadUserId();
    _loadChatRooms();
  }

  final RemoteDatasource _remoteDS;
  final MemoryStoreService _memoryStore;
  final ChatWebsocketDatasource _chatWsDs;
  late final String _uId;

  Future<void> refresh() async {
    await _loadChatRooms();
  }

  void readNoti(String chatId) {
    var notifiedChatRooms = List<String>.from(state.notifiedChatRooms);
    notifiedChatRooms.remove(chatId);

    emit(state.copyWith(notifiedChatRooms: notifiedChatRooms));
  }

  Future<void> _loadChatRooms() async {
    try {
      final chatRooms = await _remoteDS.getChatRooms(_uId);
      _listenChatRoomNoti();
      emit(state.copyWith(chatRooms: chatRooms, chatRoomsError: null));
    } catch (e) {
      emit(state.copyWith(chatRoomsError: e.toString()));
    }
  }

  void _listenChatRoomNoti() {
    _chatWsDs.chatRoomNotiStream.listen((chatRoom) {
      final (chatRooms, notifiedChatRooms) = _updateChatRoom(chatRoom);
      emit(
        state.copyWith(
          chatRooms: chatRooms,
          notifiedChatRooms: notifiedChatRooms,
        ),
      );
    });
  }

  String _loadUserId() => _memoryStore.get('userId') ?? "";

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
}
