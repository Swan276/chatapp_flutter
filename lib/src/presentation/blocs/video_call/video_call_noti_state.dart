import 'package:chatapp_ui/src/data/entities/call/init_call.dart';
import 'package:equatable/equatable.dart';

class VideoCallNotiState extends Equatable {
  const VideoCallNotiState({this.incomingCall});

  final InitCall? incomingCall;

  VideoCallNotiState copyWith({
    InitCall? incomingCall,
  }) {
    return VideoCallNotiState(
      incomingCall: incomingCall ?? this.incomingCall,
    );
  }

  @override
  List<Object?> get props => [incomingCall];
}
