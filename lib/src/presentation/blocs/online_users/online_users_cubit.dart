import 'package:chatapp_ui/src/data/datasources/remote_datasource.dart';
import 'package:chatapp_ui/src/data/datasources/websocket/user_websocket_datasource.dart';
import 'package:chatapp_ui/src/data/entities/status.dart';
import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:chatapp_ui/src/data/services/memory_store_service.dart';
import 'package:chatapp_ui/src/presentation/blocs/online_users/online_users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class OnlineUsersCubit extends Cubit<OnlineUsersState> {
  OnlineUsersCubit(
    RemoteDatasource remoteDatasource,
    MemoryStoreService memoryStoreService,
    UserWebsocketDatasource userWebsocketDatasource,
  )   : _remoteDS = remoteDatasource,
        _memoryStore = memoryStoreService,
        _userWsDs = userWebsocketDatasource,
        super(OnlineUsersState()) {
    _uId = _loadUserId();
    _loadOnlineUsers();
  }

  final RemoteDatasource _remoteDS;
  final MemoryStoreService _memoryStore;
  final UserWebsocketDatasource _userWsDs;
  late final String _uId;

  Future<void> refresh() async {
    await _loadOnlineUsers();
  }

  Future<void> _loadOnlineUsers() async {
    try {
      final onlineUsers = (await _remoteDS.getOnlineUsers())
          .where((user) => user.nickName != _uId)
          .toList();
      _listenUserUpdate();
      emit(state.copyWith(onlineUsers: onlineUsers, onlineUsersError: null));
    } catch (e) {
      emit(state.copyWith(onlineUsersError: e.toString()));
    }
  }

  void _listenUserUpdate() {
    _userWsDs.userStream.listen(
      (user) {
        final onlineUsers = _updateUser(user);
        emit(state.copyWith(onlineUsers: onlineUsers));
      },
    );
  }

  String _loadUserId() => _memoryStore.get('userId') ?? "";

  List<User> _updateUser(User user) {
    if (state.onlineUsers == null || state.onlineUsers!.isEmpty) {
      return [user];
    }

    var onlineUsers = List<User>.from(state.onlineUsers!);
    onlineUsers.removeWhere((usr) => usr.nickName == user.nickName);

    if (user.status == Status.offline) {
      return onlineUsers;
    }
    return onlineUsers..add(user);
  }
}
