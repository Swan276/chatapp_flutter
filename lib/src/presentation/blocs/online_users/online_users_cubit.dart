import 'package:chatapp_ui/src/data/datasources/remote_datasource.dart';
import 'package:chatapp_ui/src/data/datasources/websocket/user_websocket_datasource.dart';
import 'package:chatapp_ui/src/data/entities/status.dart';
import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:chatapp_ui/src/presentation/blocs/online_users/online_users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnlineUsersCubit extends Cubit<OnlineUsersState> {
  OnlineUsersCubit(
    RemoteDatasource remoteDatasource,
    UserWebsocketDatasource userWebsocketDatasource,
    User currentUser,
  )   : _remoteDS = remoteDatasource,
        _userWsDs = userWebsocketDatasource,
        _currentUser = currentUser,
        super(OnlineUsersState()) {
    _loadOnlineUsers();
  }

  final RemoteDatasource _remoteDS;
  final UserWebsocketDatasource _userWsDs;
  final User _currentUser;

  Future<void> refresh() async {
    await _loadOnlineUsers();
  }

  Future<void> _loadOnlineUsers() async {
    try {
      final onlineUsers = (await _remoteDS.getOnlineUsers())
          .where((user) => user.username != _currentUser.username)
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

  List<User> _updateUser(User user) {
    if (state.onlineUsers == null || state.onlineUsers!.isEmpty) {
      return [user];
    }

    var onlineUsers = List<User>.from(state.onlineUsers!);
    onlineUsers.removeWhere((usr) => usr.username == user.username);

    if (user.status == Status.offline) {
      return onlineUsers;
    }
    return onlineUsers..add(user);
  }
}
