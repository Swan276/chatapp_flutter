import 'dart:async';

import 'package:chatapp_ui/src/data/exceptions/session_expired_exception.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class SessionExpiredEventListener {
  SessionExpiredEventListener() {
    _sessionExpiredStreamController =
        StreamController<SessionExpiredException>();
    _sessionExpiredStream = _sessionExpiredStreamController.stream;
  }

  late final StreamController<SessionExpiredException>
      _sessionExpiredStreamController;
  late final Stream<SessionExpiredException> _sessionExpiredStream;

  void addEvent(SessionExpiredException event) {
    _sessionExpiredStreamController.add(event);
  }

  void onSessionExpired(Function(SessionExpiredException exception) action) {
    _sessionExpiredStream.listen(action);
  }
}
