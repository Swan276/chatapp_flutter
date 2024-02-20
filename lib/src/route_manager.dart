import 'package:chatapp_ui/src/data/entities/call/init_call.dart';
import 'package:chatapp_ui/src/di.dart';
import 'package:chatapp_ui/src/presentation/blocs/chat/chat_cubit.dart';
import 'package:chatapp_ui/src/presentation/pages/bottom_navigation_page.dart';
import 'package:chatapp_ui/src/presentation/pages/chat_room/chat_room_page.dart';
import 'package:chatapp_ui/src/presentation/pages/chats/chats_page.dart';
import 'package:chatapp_ui/src/presentation/pages/contacts/contacts_page.dart';
import 'package:chatapp_ui/src/presentation/pages/login/login_page.dart';
import 'package:chatapp_ui/src/presentation/pages/playground_page.dart';
import 'package:chatapp_ui/src/presentation/pages/settings/settings_page.dart';
import 'package:chatapp_ui/src/presentation/pages/video_call/video_call_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class RouteManager {
  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> chatsTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> contactsTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> settingsTabNavigatorKey =
      GlobalKey<NavigatorState>();

  static const playgroundPath = '/playground';
  static const loginPath = '/login';
  static const chatsPath = '/chats';
  static const contactsPath = '/contacts';
  static const settingsPath = '/settings';
  static const chatRoomPath = '/chats/:recipientId';
  static const videoCallPath = '/videoCall/:participantId';

  static final router = GoRouter(
    navigatorKey: parentNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: loginPath,
    routes: _routes,
  );

  static final _routes = [
    GoRoute(
      path: playgroundPath,
      pageBuilder: (context, state) {
        return _getPage(
          child: const PlaygroundPage(),
          state: state,
        );
      },
    ),
    GoRoute(
      path: loginPath,
      pageBuilder: (context, state) {
        return _getPage(
          child: const LoginPage(),
          state: state,
        );
      },
    ),
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: parentNavigatorKey,
      branches: [
        StatefulShellBranch(
          navigatorKey: chatsTabNavigatorKey,
          routes: [
            GoRoute(
              path: chatsPath,
              pageBuilder: (context, GoRouterState state) {
                return _getPage(
                  child: const ChatsPage(),
                  state: state,
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: contactsTabNavigatorKey,
          routes: [
            GoRoute(
              path: contactsPath,
              pageBuilder: (context, state) {
                return _getPage(
                  child: const ContactsPage(),
                  state: state,
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: settingsTabNavigatorKey,
          routes: [
            GoRoute(
              path: settingsPath,
              pageBuilder: (context, state) {
                return _getPage(
                  child: const SettingsPage(),
                  state: state,
                );
              },
            ),
          ],
        ),
      ],
      pageBuilder: (context, state, navigationShell) {
        return _getPage(
          child: BottomNavigationPage(child: navigationShell),
          state: state,
        );
      },
    ),
    GoRoute(
      path: chatRoomPath,
      pageBuilder: (context, state) {
        final recipientId = state.pathParameters['recipientId'] ?? "";
        // TODO: find a way to get recipient name
        return _getPage(
          child: BlocProvider<ChatCubit>(
            create: (context) => ChatCubit(
              di.get(),
              di.get(),
              di.get(),
              recipientId: recipientId,
            ),
            child: ChatRoomPage(recipientId: recipientId),
          ),
          state: state,
        );
      },
    ),
    GoRoute(
      path: videoCallPath,
      pageBuilder: (context, state) {
        final participantId = state.pathParameters['participantId'] ?? "";
        final initCall = state.extra as InitCall?;
        return _getPage(
          child: VideoCallPage(
            participantId: participantId,
            incomingCall: initCall,
          ),
          state: state,
        );
      },
    ),
  ];

  static Page _getPage({
    required Widget child,
    required GoRouterState state,
  }) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
    );
  }
}
