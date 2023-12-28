import 'package:chat_app/services/apis.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  final String callID;
  const CallPage({Key? key, required this.callID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("Call ID $callID");
    return ZegoUIKitPrebuiltCall(
        appID:
            645377989, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign:
            "272c7548fc8c136fdb14d9ac500c7bee75951a11303de09d467afeb4c8891738", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: APIs.auth.currentUser!.uid,
        userName: APIs.auth.currentUser!.displayName.toString(),
        callID: callID,

        // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        // ..onOnlySelfInRoom = () => Navigator.of(context).pop(),
        );
  }
}
