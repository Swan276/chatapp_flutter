import 'package:chatapp_ui/src/data/exceptions/session_expired_exception.dart';
import 'package:chatapp_ui/src/data/services/auth_service.dart';
import 'package:chatapp_ui/src/data/services/session_expired_event_listener.dart';
import 'package:chatapp_ui/src/utils/websocket_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'auth_state.dart';

@Injectable()
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this.authService,
    this.webSocketUtils,
    this.sessionExpiredEventListener,
  ) : super(AuthInitialState()) {
    sessionExpiredEventListener.onSessionExpired(_onSessionExpired);
  }

  final AuthService authService;
  final WebSocketUtils webSocketUtils;
  final SessionExpiredEventListener sessionExpiredEventListener;

  void checkAuthStatus() async {
    emit(AuthInitialLoadingState());

    final user = await authService.isLoggedIn();
    if (user != null) {
      _initServices(user);
      emit(AuthLoggedInState(user));
      return;
    }

    emit(AuthLoggedOutState());
  }

  void login({required String username, required String password}) async {
    try {
      emit(AuthLoginLoadingState());
      final user = await authService.login(
        username: username,
        password: password,
      );
      _initServices(user);
      emit(AuthLoggedInState(user));
    } on SessionExpiredException {
      emit(AuthLoginErrorState("Invalid Credentials"));
    } catch (e) {
      emit(AuthLoginErrorState("Something went wrong"));
    }
  }

  void register({
    required String username,
    required String fullName,
    required String password,
  }) async {
    try {
      emit(AuthSignUpLoadingState());
      final user = await authService.register(
        username: username,
        fullName: fullName,
        password: password,
      );
      _initServices(user);
      emit(AuthLoggedInState(user));
    } on SessionExpiredException {
      emit(AuthSignUpErrorState("Invalid Input"));
    } catch (e) {
      emit(AuthSignUpErrorState("Something went wrong"));
    }
  }

  void logout() async {
    await authService.logout();
    webSocketUtils.unregisterClient();
    emit(AuthLoggedOutState());
  }

  User? getCurrentUser() {
    final user = authService.currentUser;
    return user;
  }

  void _initServices(User user) {
    webSocketUtils.registerClientForServices(user);
  }

  void _onSessionExpired(SessionExpiredException exception) {
    emit(AuthSessionExpiredState());
  }
}
