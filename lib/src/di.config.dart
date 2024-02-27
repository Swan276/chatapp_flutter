// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chatapp_ui/src/data/datasources/remote_datasource.dart' as _i9;
import 'package:chatapp_ui/src/data/datasources/websocket/chat_websocket_datasource.dart'
    as _i7;
import 'package:chatapp_ui/src/data/datasources/websocket/user_websocket_datasource.dart'
    as _i10;
import 'package:chatapp_ui/src/data/datasources/websocket/video_call_websocket_datasource.dart'
    as _i11;
import 'package:chatapp_ui/src/data/services/auth_service.dart' as _i13;
import 'package:chatapp_ui/src/data/services/memory_store_service.dart' as _i3;
import 'package:chatapp_ui/src/data/services/network_service.dart' as _i8;
import 'package:chatapp_ui/src/data/services/secure_store_service.dart' as _i4;
import 'package:chatapp_ui/src/data/services/session_expired_event_listener.dart'
    as _i5;
import 'package:chatapp_ui/src/data/services/websocket_service.dart' as _i6;
import 'package:chatapp_ui/src/presentation/blocs/auth/auth_cubit.dart' as _i15;
import 'package:chatapp_ui/src/presentation/blocs/video_call/video_call_noti_cubit.dart'
    as _i14;
import 'package:chatapp_ui/src/utils/websocket_utils.dart' as _i12;
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
  gh.singleton<_i3.MemoryStoreService>(_i3.MemoryStoreService.init());
  gh.singleton<_i4.SecureStoreService>(_i4.SecureStoreService.init());
  gh.singleton<_i5.SessionExpiredEventListener>(
      _i5.SessionExpiredEventListener());
  gh.singleton<_i6.WebsocketService>(
      _i6.WebsocketService(gh<_i4.SecureStoreService>()));
  gh.singleton<_i7.ChatWebsocketDatasource>(_i7.ChatWebsocketDatasource(
      websocketService: gh<_i6.WebsocketService>()));
  gh.singleton<_i8.NetworkService>(_i8.NetworkService.init(
    gh<_i4.SecureStoreService>(),
    gh<_i5.SessionExpiredEventListener>(),
  ));
  gh.factory<_i9.RemoteDatasource>(
      () => _i9.RemoteDatasource(gh<_i8.NetworkService>()));
  gh.singleton<_i10.UserWebsocketDatasource>(_i10.UserWebsocketDatasource(
      websocketService: gh<_i6.WebsocketService>()));
  gh.singleton<_i11.VideoCallWebsocketDatasource>(
      _i11.VideoCallWebsocketDatasource(
          websocketService: gh<_i6.WebsocketService>()));
  gh.factory<_i12.WebSocketUtils>(() => _i12.WebSocketUtils(
        gh<_i6.WebsocketService>(),
        gh<_i10.UserWebsocketDatasource>(),
        gh<_i7.ChatWebsocketDatasource>(),
        gh<_i11.VideoCallWebsocketDatasource>(),
      ));
  gh.factory<_i13.AuthService>(() => _i13.AuthService(
        gh<_i4.SecureStoreService>(),
        gh<_i9.RemoteDatasource>(),
      ));
  gh.factory<_i14.VideoCallNotiCubit>(
      () => _i14.VideoCallNotiCubit(gh<_i11.VideoCallWebsocketDatasource>()));
  gh.factory<_i15.AuthCubit>(() => _i15.AuthCubit(
        gh<_i13.AuthService>(),
        gh<_i12.WebSocketUtils>(),
        gh<_i5.SessionExpiredEventListener>(),
      ));
  return getIt;
}
