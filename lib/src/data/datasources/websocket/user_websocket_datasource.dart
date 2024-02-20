import 'dart:async';

import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:chatapp_ui/src/data/services/websocket_service.dart';
import 'package:injectable/injectable.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

@Singleton()
class UserWebsocketDatasource {
  final WebsocketService websocketService;

  late StreamController<User> _userStreamController;
  late Stream<User> userStream;
  String? _uId;

  UserWebsocketDatasource({
    required this.websocketService,
  });

  void registerClient(User user) {
    _uId ??= user.nickName;
    _userStreamController = StreamController<User>.broadcast();
    userStream = _userStreamController.stream;
    websocketService.subscribe(
      SocketSubscription(
        destination: '/user/public',
        callback: _onPublicMessageReceived,
      ),
    );
  }

  void _onPublicMessageReceived(StompFrame frame) {
    final payload = frame.body;
    if (payload == null) return;
    final user = User.fromJson(payload);
    if (user.nickName != _uId) {
      _userStreamController.add(user);
    }
  }

  void unregisterClient() {
    _uId = null;
    _userStreamController.close();
  }
}
