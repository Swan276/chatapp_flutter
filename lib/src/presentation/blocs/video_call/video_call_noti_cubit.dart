import 'package:chatapp_ui/src/data/datasources/websocket/video_call_websocket_datasource.dart';
import 'package:chatapp_ui/src/presentation/blocs/video_call/video_call_noti_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class VideoCallNotiCubit extends Cubit<VideoCallNotiState> {
  VideoCallNotiCubit(VideoCallWebsocketDatasource videoCallWebsocketDatasource)
      : _videoCallWsDs = videoCallWebsocketDatasource,
        super(const VideoCallNotiState()) {
    _listenVideoCallNoti();
  }

  final VideoCallWebsocketDatasource _videoCallWsDs;

  void rejectCall() {
    final callerId = state.incomingCall?.participantId;
    if (callerId != null) {
      _videoCallWsDs.rejectCall(callerId);
    }
  }

  void _listenVideoCallNoti() {
    _videoCallWsDs.incomingCallStream.listen((incomingCall) {
      emit(state.copyWith(incomingCall: incomingCall));
    });
  }
}
