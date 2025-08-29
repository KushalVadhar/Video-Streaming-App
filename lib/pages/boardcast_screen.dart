import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_streaming_app/config/app_id.dart';
import 'package:video_streaming_app/pages/home_screen.dart';
import 'package:video_streaming_app/providers/user_provider.dart';
import 'package:video_streaming_app/resources/firestore_methods.dart';
import 'package:video_streaming_app/widgets/chat.dart';
import 'package:http/http.dart' as http;

class BroadcastScreen extends StatefulWidget {
  final bool isBroadcaster;
  final String channelId;

  const BroadcastScreen({
    super.key,
    required this.isBroadcaster,
    required this.channelId,
  });

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  late final RtcEngine _engine;
  final List<int> _remoteUid = [];
  bool switchCamera = true;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  void _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId));
    _addListeners();
    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine
        .setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    if (widget.isBroadcaster) {
      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    } else {
      await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
    }

    _joinChannel();
  }

  String baseurl = "https://backendgoagoraserver-production.up.railway.app/";

  String? token;

  Future<void> getToken() async {
    try {
      final res = await http.get(Uri.parse(baseurl +
          '/rtc/' +
          widget.channelId +
          '/publisher/userAccount/' +
          Provider.of<UserProvider>(context, listen: false).user.uid +
          '/'));

      if (res.statusCode == 200) {
        setState(() {
          token = jsonDecode(res.body)['rtcToken'];
        });
      } else {
        debugPrint('Failed to fetch the token');
      }
    } catch (e) {
      debugPrint('Error fetching token: $e');
    }
  }

  void _addListeners() {
    _engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        debugPrint("local user ${connection.localUid} joined $elapsed");
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        debugPrint("remote user $remoteUid joined  $elapsed");
        setState(() {
          _remoteUid.add(remoteUid);
        });
      },
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        debugPrint("remote user $remoteUid left channel $reason");
        setState(() {
          _remoteUid.remove(remoteUid);
        });
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        debugPrint('User left channel with stats: $stats');
        setState(() {
          _remoteUid.clear();
        });
      },
      onTokenPrivilegeWillExpire: (connection, token) async {
        await getToken();
        await _engine.renewToken(token);
      },
    ));
  }

  void _joinChannel() async {
    await getToken();

    if (token == null) {
      debugPrint('Token is null. Unable to join channel.');
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }

    await _engine.joinChannelWithUserAccount(
      token: token!,
      channelId: widget.channelId,
      userAccount: Provider.of<UserProvider>(context, listen: false).user.uid,
    );
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    if (!mounted) return;
    if ('${Provider.of<UserProvider>(context, listen: false).user.uid} ${Provider.of<UserProvider>(context, listen: false).user.username}' ==
        widget.channelId) {
      await FirestoreMethods().endLiveStream(widget.channelId);
    } else {
      await FirestoreMethods().updateViewCount(widget.channelId, false);
    }
    if (!mounted) return;
    Navigator.pushReplacement(
        context, (MaterialPageRoute(builder: (context) => HomeScreen())));
  }

  void _switchCamera() {
    _engine.switchCamera().then((value) {
      setState(() {
        switchCamera = !switchCamera;
      });
    }).catchError((err) {
      debugPrint('SwitchCamera $err');
    });
  }

  void _onToogleMute() async {
    setState(() {
      isMuted = !isMuted;
    });
    await _engine.muteLocalAudioStream(isMuted);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) async {
        await _leaveChannel();
        return Future.value(true);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scaffold(
          body: Column(
            children: [
              _renderVideo(user),
              if ("${user.uid}${user.username}" == widget.channelId)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: _switchCamera,
                      child: Text('Switch Camera'),
                    ),
                    InkWell(
                      onTap: _onToogleMute,
                      child: Text(isMuted ? 'UnMute' : 'Mute'),
                    )
                  ],
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                    child: Chat(
                  channelId: widget.channelId,
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderVideo(user) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: "${user.uid}${user.username}" == widget.channelId
          ? kIsWeb
              ? AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine,
                    canvas: const VideoCanvas(
                      uid: 0,
                    ),
                  ),
                )
              : AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine,
                    canvas: const VideoCanvas(
                      uid: 0,
                    ),
                  ),
                )
          : _remoteUid.isNotEmpty
              ? kIsWeb
                  ? AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: _engine,
                        canvas: VideoCanvas(
                          uid: _remoteUid[0],
                        ),
                        connection: RtcConnection(channelId: widget.channelId),
                      ),
                    )
                  : AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: _engine,
                        canvas: VideoCanvas(
                          uid: _remoteUid[0],
                        ),
                        connection: RtcConnection(channelId: widget.channelId),
                      ),
                    )
              : Container(),
    );
  }
}
