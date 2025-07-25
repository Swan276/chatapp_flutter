import 'package:chatapp_ui/src/presentation/blocs/video_call/video_call_noti_cubit.dart';
import 'package:chatapp_ui/src/presentation/blocs/video_call/video_call_noti_state.dart';
import 'package:chatapp_ui/src/presentation/common/ui_colors.dart';
import 'package:chatapp_ui/src/presentation/widgets/video_call_noti_snackbar.dart';
import 'package:chatapp_ui/src/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<VideoCallNotiCubit, VideoCallNotiState>(
      listener: (context, state) {
        if (state.incomingCall != null) {
          ScaffoldFeatureController? controller;
          controller = ScaffoldMessenger.of(context).showSnackBar(
            VideoCallNotiSnackbar(
              callerName: state.incomingCall!.participantName ??
                  state.incomingCall!.participantId,
              onCallAccept: () {
                RouteManager.parentNavigatorKey.currentContext!.push(
                  "/videoCall/${state.incomingCall!.participantId}",
                  extra: state.incomingCall!,
                );
                controller?.close();
              },
              onCallReject: () {
                context.read<VideoCallNotiCubit>().rejectCall();
                controller?.close();
              },
            ).build(context),
          );
        }
      },
      child: Scaffold(
        backgroundColor: UIColors.background,
        body: SafeArea(child: widget.child),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.child.currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Icon(Icons.chat),
              ),
              label: "Chats",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Icon(Icons.person),
              ),
              label: "Profile",
            ),
          ],
          onTap: (index) {
            widget.child.goBranch(
              index,
              initialLocation: index == 0,
            );
            setState(() {});
          },
          backgroundColor: UIColors.primarySurface,
          selectedItemColor: UIColors.primary,
          unselectedItemColor: UIColors.surface60,
        ),
      ),
    );
  }
}
