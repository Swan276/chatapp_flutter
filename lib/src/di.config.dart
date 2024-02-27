// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chatapp_ui/src/data/datasources/remote_datasource.dart' as _i8;
import 'package:chatapp_ui/src/data/datasources/websocket/chat_websocket_datasource.dart'
    as _i6;
import 'package:chatapp_ui/src/data/datasources/websocket/user_websocket_datasource.dart'
    as _i9;
import 'package:chatapp_ui/src/data/datasources/websocket/video_call_websocket_datasource.dart'
    as _i10;
import 'package:chatapp_ui/src/data/services/auth_service.dart' as _i12;
import 'package:chatapp_ui/src/data/services/network_service.dart' as _i7;
import 'package:chatapp_ui/src/data/services/secure_store_service.dart' as _i3;
import 'package:chatapp_ui/src/data/services/session_expired_event_listener.dart'
    as _i4;
import 'package:chatapp_ui/src/data/services/websocket_service.dart' as _i5;
import 'package:chatapp_ui/src/presentation/blocs/auth/auth_cubit.dart' as _i14;
import 'package:chatapp_ui/src/presentation/blocs/video_call/video_call_noti_cubit.dart'
    as _i13;
import 'package:chatapp_ui/src/utils/websocket_utils.dart' as _i11;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt init(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.singleton<_i3.SecureStoreService>(_i3.SecureStoreService.init());
  gh.singleton<_i4.SessionExpiredEventListener>(
      _i4.SessionExpiredEventListener());
  gh.singleton<_i5.WebsocketService>(
      _i5.WebsocketService(gh<_i3.SecureStoreService>()));
  gh.singleton<_i6.ChatWebsocketDatasource>(_i6.ChatWebsocketDatasource(
      websocketService: gh<_i5.WebsocketService>()));
  gh.singleton<_i7.NetworkService>(_i7.NetworkService.init(
    gh<_i3.SecureStoreService>(),
    gh<_i4.SessionExpiredEventListener>(),
  ));
  gh.factory<_i8.RemoteDatasource>(
      () => _i8.RemoteDatasource(gh<_i7.NetworkService>()));
  gh.singleton<_i9.UserWebsocketDatasource>(_i9.UserWebsocketDatasource(
      websocketService: gh<_i5.WebsocketService>()));
  gh.singleton<_i10.VideoCallWebsocketDatasource>(
      _i10.VideoCallWebsocketDatasource(
          websocketService: gh<_i5.WebsocketService>()));
  gh.factory<_i11.WebSocketUtils>(() => _i11.WebSocketUtils(
        gh<_i5.WebsocketService>(),
        gh<_i9.UserWebsocketDatasource>(),
        gh<_i6.ChatWebsocketDatasource>(),
        gh<_i10.VideoCallWebsocketDatasource>(),
      ));
  gh.factory<_i12.AuthService>(() => _i12.AuthService(
        gh<_i3.SecureStoreService>(),
        gh<_i8.RemoteDatasource>(),
      ));
  gh.factory<_i13.VideoCallNotiCubit>(
      () => _i13.VideoCallNotiCubit(gh<_i10.VideoCallWebsocketDatasource>()));
  gh.factory<_i14.AuthCubit>(() => _i14.AuthCubit(
        gh<_i12.AuthService>(),
        gh<_i11.WebSocketUtils>(),
        gh<_i4.SessionExpiredEventListener>(),
      ));
  return getIt;
}
