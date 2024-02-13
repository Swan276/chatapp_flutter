import 'dart:typed_data';

import 'package:chatapp_ui/src/constants/api_constants.dart';
import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

@Singleton()
class WebsocketService {
  late StompClient _stompClient;
  final Set<SocketSubscription> _subscriptions = {};

  void registerClient(User user) {
    _stompClient = StompClient(
      config: StompConfig.sockJS(
        url: '${ApiConstants.baseUrl}/${ApiConstants.websocketChannel}',
        stompConnectHeaders: {"userId": user.nickName},
        onWebSocketError: (dynamic error) => print(error.toString()),
        onConnect: (frame) {
          send(
            destination: "/app/user.addUser",
            body: user.toJson(),
          );
          for (SocketSubscription sub in _subscriptions) {
            _stompClient.subscribe(
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
    _stompClient.activate();
  }

  void subscribe(SocketSubscription subscription) {
    _subscriptions.add(subscription);
  }

  void send({
    required String destination,
    Map<String, String>? headers,
    String? body,
    Uint8List? binaryBody,
  }) {
    _stompClient.send(
      destination: destination,
      headers: headers,
      body: body,
      binaryBody: binaryBody,
    );
  }

  void unregisterClient() {
    _subscriptions.clear();
    _stompClient.deactivate();
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
