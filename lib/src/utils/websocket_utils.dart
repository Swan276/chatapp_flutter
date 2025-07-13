import 'package:chatapp_ui/src/data/datasources/websocket/chat_websocket_datasource.dart';
import 'package:chatapp_ui/src/data/datasources/websocket/user_websocket_datasource.dart';
import 'package:chatapp_ui/src/data/datasources/websocket/video_call_websocket_datasource.dart';
import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:chatapp_ui/src/data/services/websocket_service.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class WebSocketUtils {
  final WebsocketService websocketService;
  final UserWebsocketDatasource userWebsocketDatasource;
  final ChatWebsocketDatasource chatWebsocketDatasource;
  final VideoCallWebsocketDatasource videoCallWebsocketDatasource;

  const WebSocketUtils(
    this.websocketService,
    this.userWebsocketDatasource,
    this.chatWebsocketDatasource,
    this.videoCallWebsocketDatasource,
  );

  void registerClientForServices(User user) {
    userWebsocketDatasource.registerClient(user);
    chatWebsocketDatasource.registerClient(user);
    videoCallWebsocketDatasource.registerClient(user);
    websocketService.registerClient(user);
  }

  void unregisterClient() {
    userWebsocketDatasource.unregisterClient();
    chatWebsocketDatasource.unregisterClient();
    videoCallWebsocketDatasource.unregisterClient();
    websocketService.unregisterClient();
  }
}
