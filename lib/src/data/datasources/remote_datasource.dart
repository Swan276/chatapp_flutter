import 'package:chatapp_ui/src/data/entities/chat_message.dart';
import 'package:chatapp_ui/src/data/entities/chat_room.dart';
import 'package:chatapp_ui/src/data/entities/register_user.dart';
import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:chatapp_ui/src/data/services/network_service.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class RemoteDatasource {
  RemoteDatasource(NetworkService networkService)
      : _networkService = networkService;

  final NetworkService _networkService;

  Future<User> login(String username, String password) async {
    final response = await _networkService.post(
      '/auth/login',
      body: {
        'username': username,
        'password': password,
      },
      retrieveToken: true,
    );
    if (response.statusCode == 403) {
      throw Exception("Wrong Credentials");
    }
    final user = User.fromMap(response.data['user']);
    return user;
  }

  Future<User> signup(RegisterUser registerUser) async {
    final response = await _networkService.post(
      '/auth/register',
      body: registerUser.toMap(),
      retrieveToken: true,
    );
    if (response.statusCode == 403) {
      throw Exception("Invalid Credentials");
    }
    final user = User.fromMap(response.data['user']);
    return user;
  }

  Future<List<User>> getOnlineUsers() async {
    final response = await _networkService.get(
      '/users',
      attachToken: true,
    );
    final onlineUsers = (response.data as List)
        .map((userJson) => User.fromMap(userJson))
        .toList();
    return onlineUsers;
  }

  Future<List<ChatRoom>> getChatRooms(String userId) async {
    final response = await _networkService.get(
      '/chatRooms/$userId',
      attachToken: true,
    );
    final chatRooms = (response.data as List)
        .map((chatRoomJson) => ChatRoom.fromMap(chatRoomJson))
        .toList();
    return chatRooms;
  }

  Future<List<ChatMessage>> getChatMessages(
      String userId, String recipientId) async {
    final response = await _networkService.get(
      '/messages/$userId/$recipientId',
      attachToken: true,
    );
    final chatMessages = (response.data as List)
        .map((chatMessageJson) => ChatMessage.fromMap(chatMessageJson))
        .toList();
    return chatMessages;
  }
}
