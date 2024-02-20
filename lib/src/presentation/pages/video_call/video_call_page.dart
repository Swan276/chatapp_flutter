import 'dart:developer';

import 'package:chatapp_ui/src/data/datasources/websocket/video_call_websocket_datasource.dart';
import 'package:chatapp_ui/src/data/entities/call/ice_candidate.dart';
import 'package:chatapp_ui/src/data/entities/call/init_call.dart';
import 'package:chatapp_ui/src/data/entities/call/reply_call.dart';
import 'package:chatapp_ui/src/data/entities/call/rtc_ice_candidate_mapper.dart';
import 'package:chatapp_ui/src/di.dart';
import 'package:chatapp_ui/src/presentation/common/ui_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCallPage extends StatelessWidget {
  const VideoCallPage({
    super.key,
    required this.participantId,
    required this.incomingCall,
  });

  final String participantId;
  // if it's null user is caller, else user is callee
  final InitCall? incomingCall;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: VideoCallContent(
          participantId: participantId,
          offer: incomingCall?.sdpOffer,
        ),
      ),
    );
  }
}

class VideoCallContent extends StatefulWidget {
  const VideoCallContent({
    super.key,
    required this.participantId,
    required this.offer,
  });

  final String participantId;
  final dynamic offer;

  @override
  State<VideoCallContent> createState() => _VideoCallContentState();
}

class _VideoCallContentState extends State<VideoCallContent> {
  // socket instance
  final videocallWsDs = di.get<VideoCallWebsocketDatasource>();

  // videoRenderer for localPeer
  final _localRTCVideoRenderer = RTCVideoRenderer();

  // videoRenderer for remotePeer
  final _remoteRTCVideoRenderer = RTCVideoRenderer();

  // mediaStream for localPeer
  MediaStream? _localStream;

  // RTC peer connection
  RTCPeerConnection? _rtcPeerConnection;

  // list of rtcCandidates to be sent over signalling
  List<RTCIceCandidate> rtcIceCadidates = [];

  // media status
  bool isAudioOn = true, isVideoOn = true, isFrontCameraSelected = true;

  bool isCallRejected = false;

  @override
  void initState() {
    // initializing renderers
    _localRTCVideoRenderer.initialize();
    _remoteRTCVideoRenderer.initialize();

    // setup Peer Connection
    _setupPeerConnection();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _setupPeerConnection() async {
    // create peer connection
    _rtcPeerConnection = await createPeerConnection({
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302'
          ]
        }
      ]
    });

    // listen for remotePeer mediaTrack event
    _rtcPeerConnection!.onTrack = (event) {
      _remoteRTCVideoRenderer.srcObject = event.streams[0];
      setState(() {});
    };

    // get localStream
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': isAudioOn,
      'video': isVideoOn
          ? {'facingMode': isFrontCameraSelected ? 'user' : 'environment'}
          : false,
    });

    // add mediaTrack to peerConnection
    _localStream!.getTracks().forEach((track) {
      _rtcPeerConnection!.addTrack(track, _localStream!);
    });

    // set source for local video renderer
    _localRTCVideoRenderer.srcObject = _localStream;
    setState(() {});

    // for Incoming call
    if (widget.offer != null) {
      // set SDP offer as remoteDescription for peerConnection
      await _rtcPeerConnection!.setRemoteDescription(
        RTCSessionDescription(widget.offer["sdp"], widget.offer["type"]),
      );

      // create SDP answer
      RTCSessionDescription answer = await _rtcPeerConnection!.createAnswer();

      // send SDP answer to remote peer over signalling
      videocallWsDs.answerCall(
        ReplyCall(
          participantId: widget.participantId,
          sdpAnswer: answer.toMap(),
        ),
      );

      // set SDP answer as localDescription for peerConnection
      _rtcPeerConnection!.setLocalDescription(answer);

      // listen for Remote IceCandidate
      videocallWsDs.incomingIceCandidateStream?.listen((iceCandidate) {
        _rtcPeerConnection!.addCandidate(iceCandidate);
      });
    }
    // for Outgoing Call
    else {
      // create SDP Offer
      RTCSessionDescription offer = await _rtcPeerConnection!.createOffer();

      // set SDP offer as localDescription for peerConnection
      await _rtcPeerConnection!.setLocalDescription(offer);

      // listen for local iceCandidate and add it to the list of IceCandidate
      _rtcPeerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
        rtcIceCadidates.add(candidate);
      };

      // make a call to remote peer over signalling
      videocallWsDs
          .makeCall(
        InitCall(
          participantId: widget.participantId,
          participantName: "Swan",
          sdpOffer: offer.toMap(),
        ),
      )
          .then((replyCall) async {
        if (replyCall.isRejected) {
          setState(() {
            isCallRejected = true;
          });
          return;
        }
        // when call is accepted by remote peer
        await _rtcPeerConnection!.setRemoteDescription(
          RTCSessionDescription(
            replyCall.sdpAnswer["sdp"],
            replyCall.sdpAnswer["type"],
          ),
        );
        log("Queued Candidates: $rtcIceCadidates", name: "rtc_log");
        for (var candidate in rtcIceCadidates) {
          videocallWsDs.offerIceCandidate(
            IceCandidate(
              participantId: widget.participantId,
              iceCandidate: RtcIceCandidateMapper(
                id: candidate.sdpMid,
                candidate: candidate.candidate,
                label: candidate.sdpMLineIndex,
              ),
            ),
          );
        }
      });
    }
  }

  _leaveCall() {
    videocallWsDs.endCall();
    Navigator.pop(context);
  }

  _toggleMic() {
    // change status
    isAudioOn = !isAudioOn;
    // enable or disable audio track
    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = isAudioOn;
    });
    setState(() {});
  }

  _toggleCamera() {
    // change status
    isVideoOn = !isVideoOn;

    // enable or disable video track
    _localStream?.getVideoTracks().forEach((track) {
      track.enabled = isVideoOn;
    });
    setState(() {});
  }

  _switchCamera() {
    // change status
    isFrontCameraSelected = !isFrontCameraSelected;

    // switch camera
    _localStream?.getVideoTracks().forEach((track) {
      // ignore: deprecated_member_use
      track.switchCamera();
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: null,
        centerTitle: true,
        title: Text(
          widget.participantId,
          style: const TextStyle(color: UIColors.surface60),
        ),
      ),
      body: SafeArea(
        child: isCallRejected
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Call is Rejected",
                      style: TextStyle(
                        fontSize: 24,
                        color: UIColors.surface60,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _leaveCall,
                      child: const Text("Leave"),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Stack(children: [
                      RTCVideoView(
                        _remoteRTCVideoRenderer,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      ),
                      Positioned(
                        right: 20,
                        bottom: 20,
                        child: SizedBox(
                          height: 150,
                          width: 120,
                          child: RTCVideoView(
                            _localRTCVideoRenderer,
                            mirror: isFrontCameraSelected,
                            objectFit: RTCVideoViewObjectFit
                                .RTCVideoViewObjectFitCover,
                          ),
                        ),
                      )
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(isAudioOn ? Icons.mic : Icons.mic_off),
                          onPressed: _toggleMic,
                        ),
                        IconButton(
                          icon: const Icon(Icons.call_end),
                          iconSize: 30,
                          onPressed: _leaveCall,
                        ),
                        IconButton(
                          icon: const Icon(Icons.cameraswitch),
                          onPressed: _switchCamera,
                        ),
                        IconButton(
                          icon: Icon(
                              isVideoOn ? Icons.videocam : Icons.videocam_off),
                          onPressed: _toggleCamera,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _localRTCVideoRenderer.dispose();
    _remoteRTCVideoRenderer.dispose();
    _localStream?.dispose();
    _rtcPeerConnection?.dispose();
    super.dispose();
  }
}
