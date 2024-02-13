import 'package:chatapp_ui/src/data/datasources/websocket/chat_websocket_datasource.dart';
import 'package:chatapp_ui/src/data/datasources/websocket/user_websocket_datasource.dart';
import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:chatapp_ui/src/data/services/websocket_service.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class WebSocketUtils {
  final WebsocketService websocketService;
  final UserWebsocketDatasource userWebsocketDatasource;
  final ChatWebsocketDatasource chatWebsocketDatasource;

  const WebSocketUtils(
    this.websocketService,
    this.userWebsocketDatasource,
    this.chatWebsocketDatasource,
  );

  void registerClientForServices(User user) {
    userWebsocketDatasource.registerClient(user);
    chatWebsocketDatasource.registerClient(user);
    websocketService.registerClient(user);
  }

  void unregisterClient() {
    websocketService.unregisterClient();
  }
}
