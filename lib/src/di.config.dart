// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chatapp_ui/src/data/datasources/remote_datasource.dart' as _i5;
import 'package:chatapp_ui/src/data/datasources/websocket/chat_websocket_datasource.dart'
    as _i7;
import 'package:chatapp_ui/src/data/datasources/websocket/user_websocket_datasource.dart'
    as _i8;
import 'package:chatapp_ui/src/data/services/memory_store_service.dart' as _i3;
import 'package:chatapp_ui/src/data/services/network_service.dart' as _i4;
import 'package:chatapp_ui/src/data/services/websocket_service.dart' as _i6;
import 'package:chatapp_ui/src/presentation/blocs/chat_rooms/chat_rooms_cubit.dart'
    as _i10;
import 'package:chatapp_ui/src/presentation/blocs/online_users/online_users_cubit.dart'
    as _i11;
import 'package:chatapp_ui/src/utils/websocket_utils.dart' as _i9;
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
  gh.singleton<_i4.NetworkService>(_i4.NetworkService.init());
  gh.factory<_i5.RemoteDatasource>(
      () => _i5.RemoteDatasource(gh<_i4.NetworkService>()));
  gh.singleton<_i6.WebsocketService>(_i6.WebsocketService());
  gh.singleton<_i7.ChatWebsocketDatasource>(_i7.ChatWebsocketDatasource(
      websocketService: gh<_i6.WebsocketService>()));
  gh.singleton<_i8.UserWebsocketDatasource>(_i8.UserWebsocketDatasource(
      websocketService: gh<_i6.WebsocketService>()));
  gh.factory<_i9.WebSocketUtils>(() => _i9.WebSocketUtils(
        gh<_i6.WebsocketService>(),
        gh<_i8.UserWebsocketDatasource>(),
        gh<_i7.ChatWebsocketDatasource>(),
      ));
  gh.factory<_i10.ChatRoomsCubit>(() => _i10.ChatRoomsCubit(
        gh<_i5.RemoteDatasource>(),
        gh<_i3.MemoryStoreService>(),
        gh<_i7.ChatWebsocketDatasource>(),
      ));
  gh.factory<_i11.OnlineUsersCubit>(() => _i11.OnlineUsersCubit(
        gh<_i5.RemoteDatasource>(),
        gh<_i3.MemoryStoreService>(),
        gh<_i8.UserWebsocketDatasource>(),
      ));
  return getIt;
}
