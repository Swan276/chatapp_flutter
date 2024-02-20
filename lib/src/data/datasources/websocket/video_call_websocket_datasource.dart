import 'dart:async';

import 'package:chatapp_ui/src/data/entities/call/ice_candidate.dart';
import 'package:chatapp_ui/src/data/entities/call/reply_call.dart';
import 'package:chatapp_ui/src/data/entities/call/init_call.dart';
import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:chatapp_ui/src/data/services/websocket_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

@Singleton()
class VideoCallWebsocketDatasource {
  final WebsocketService websocketService;

  late StreamController<InitCall> _incomingCallStreamController;
  late Stream<InitCall> incomingCallStream;
  StreamController<RTCIceCandidate>? _incomingIceCandidateController;
  Stream<RTCIceCandidate>? incomingIceCandidateStream;
  Completer<ReplyCall>? callCompleter;

  String? _uId;

  VideoCallWebsocketDatasource({
    required this.websocketService,
  });

  void registerClient(User user) {
    _uId ??= user.nickName;
    _incomingCallStreamController = StreamController<InitCall>.broadcast();
    incomingCallStream = _incomingCallStreamController.stream;

    websocketService.subscribe(
      SocketSubscription(
        destination: '/user/$_uId/newCall',
        callback: _onCallReceived,
      ),
    );
    websocketService.subscribe(
      SocketSubscription(
        destination: '/user/$_uId/callAnswered',
        callback: _onCallAnswered,
      ),
    );
    websocketService.subscribe(
      SocketSubscription(
        destination: '/user/$_uId/callRejected',
        callback: _onCallRejected,
      ),
    );
    websocketService.subscribe(
      SocketSubscription(
        destination: '/user/$_uId/IceCandidate',
        callback: _onIceCandidateReceived,
      ),
    );
  }

  Future<ReplyCall> makeCall(InitCall offerCall) {
    websocketService.send(
      destination: '/app/makeCall',
      body: offerCall.toJson(),
      headers: {"userId": _uId!},
    );
    callCompleter = Completer<ReplyCall>();
    return callCompleter!.future;
  }

  void answerCall(ReplyCall replyCall) {
    websocketService.send(
      destination: '/app/answerCall',
      body: replyCall.toJson(),
      headers: {"userId": _uId!},
    );
    _incomingIceCandidateController =
        StreamController<RTCIceCandidate>.broadcast();
    incomingIceCandidateStream = _incomingIceCandidateController!.stream;
  }

  void rejectCall(String callerId) {
    websocketService.send(
      destination: '/app/rejectCall',
      body: ReplyCall(participantId: callerId, sdpAnswer: null).toJson(),
      headers: {"userId": _uId!},
    );
  }

  void offerIceCandidate(IceCandidate iceCandidate) {
    websocketService.send(
      destination: '/app/IceCandidate',
      body: iceCandidate.toJson(),
      headers: {"userId": _uId!},
    );
  }

  void _onCallReceived(StompFrame frame) {
    final payload = frame.body;
    if (payload == null) return;
    final incomingCall = InitCall.fromJson(payload);
    _incomingCallStreamController.add(incomingCall);
  }

  void _onCallAnswered(StompFrame frame) {
    final payload = frame.body;
    if (payload == null) return;
    final answeredCall = ReplyCall.fromJson(payload);
    callCompleter?.complete(answeredCall);
  }

  void _onCallRejected(StompFrame frame) {
    final payload = frame.body;
    if (payload == null) return;
    final rejectedCall = ReplyCall.fromJson(payload);
    callCompleter?.complete(rejectedCall);
  }

  void _onIceCandidateReceived(StompFrame frame) {
    final payload = frame.body;
    if (payload == null) return;
    final iceCandidate = IceCandidate.fromJson(payload);
    final rtcIceCandidate = iceCandidate.iceCandidate.getRTCIceCandidate();
    _incomingIceCandidateController?.add(rtcIceCandidate);
  }

  void endCall() {
    _incomingIceCandidateController?.close();
    incomingIceCandidateStream = null;
    callCompleter = null;
  }

  void unregisterClient() {
    _uId = null;
    _incomingCallStreamController.close();
    _incomingIceCandidateController?.close();
    callCompleter = null;
  }
}
