import 'package:chatapp_ui/src/di.dart';
import 'package:chatapp_ui/src/presentation/blocs/auth/auth_cubit.dart';
import 'package:chatapp_ui/src/presentation/blocs/video_call/video_call_noti_cubit.dart';
import 'package:chatapp_ui/src/presentation/common/ui_colors.dart';
import 'package:chatapp_ui/src/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => di.get(),
        ),
        BlocProvider<VideoCallNotiCubit>(
          create: (context) => di.get(),
        ),
      ],
      child: const _AppWrapper(),
    );
  }
}

class _AppWrapper extends StatelessWidget {
  const _AppWrapper();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSessionExpiredState) {
          showDialog(
            context: RouteManager.parentNavigatorKey.currentContext ?? context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                title: const Text("Session Expired.\nPlease login again"),
                titleTextStyle: const TextStyle(
                  color: UIColors.surface20,
                  fontSize: 20,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      context.read<AuthCubit>().logout();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        } else if (state is AuthLoggedInState) {
          RouteManager.parentNavigatorKey.currentContext
              ?.replace(RouteManager.chatsPath);
        } else if (state is AuthLoggedOutState) {
          RouteManager.parentNavigatorKey.currentContext
              ?.replace(RouteManager.loginPath);
        }
      },
      child: MaterialApp.router(
        routerConfig: RouteManager.router,
        title: 'Chat App',
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: UIColors.primary).copyWith(
            primary: UIColors.primary,
            surface: UIColors.primarySurface,
            primaryContainer: UIColors.primaryContainer,
            onPrimaryContainer: UIColors.onPrimaryContainer,
            secondary: UIColors.secondarySurface,
            background: UIColors.background,
          ),
          textTheme: GoogleFonts.interTextTheme(),
          useMaterial3: true,
        ),
      ),
    );
  }
}
