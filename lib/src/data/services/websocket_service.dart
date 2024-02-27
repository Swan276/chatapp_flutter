import 'dart:typed_data';

import 'package:chatapp_ui/src/constants/api_constants.dart';
import 'package:chatapp_ui/src/constants/constants.dart';
import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:chatapp_ui/src/data/services/secure_store_service.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

@Singleton()
class WebsocketService {
  WebsocketService(SecureStoreService secureStoreService)
      : _secureStoreService = secureStoreService;

  final SecureStoreService _secureStoreService;

  StompClient? _stompClient;
  final Set<SocketSubscription> _subscriptions = {};

  void registerClient(User user) async {
    final token = await _secureStoreService.get(key: jwtTokenKey);
    _stompClient = StompClient(
      config: StompConfig(
        url:
            '${ApiConstants.websocketBaseUrl}/${ApiConstants.websocketChannel}',
        webSocketConnectHeaders: {
          "Authorization": "Bearer $token",
        },
        stompConnectHeaders: {
          "userId": user.username,
        },
        onWebSocketError: (dynamic error) {
          print(error.toString());
        },
        onConnect: (frame) {
          send(
            destination: "/app/setUserOnline",
            body: user.toJson(),
          );
          for (SocketSubscription sub in _subscriptions) {
            _stompClient!.subscribe(
              destination: sub.destination,
              callback: sub.callback,
              headers: sub.headers,
            );
          }
        },
        onDisconnect: (frame) {
          print("Disconnecting $frame");
        },
      ),
    );
    _stompClient!.activate();
  }

  void subscribe(SocketSubscription subscription) {
    if (_stompClient != null && _stompClient!.isActive) {
      _stompClient!.subscribe(
        destination: subscription.destination,
        callback: subscription.callback,
        headers: subscription.headers,
      );
      return;
    }
    _subscriptions.add(subscription);
  }

  void send({
    required String destination,
    Map<String, String>? headers,
    String? body,
    Uint8List? binaryBody,
  }) {
    _stompClient?.send(
      destination: destination,
      headers: headers,
      body: body,
      binaryBody: binaryBody,
    );
  }

  void unregisterClient() {
    _subscriptions.clear();
    _stompClient?.deactivate();
    _stompClient = null;
  }
}

class SocketSubscription extends Equatable {
  final String destination;
  final StompFrameCallback callback;
  final Map<String, String>? headers;

  const SocketSubscription({
    required this.destination,
    required this.callback,
    this.headers,
  });

  @override
  List<Object?> get props => [destination];
}
