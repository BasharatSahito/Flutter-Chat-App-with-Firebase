import 'package:chat_app/services/apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  final String callID;
  const CallPage({Key? key, required this.callID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        appID: int.tryParse(dotenv.env['ZEGO_APP_ID'] ?? '') ??
            0, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign: dotenv.env['ZEGO_APP_SIGN'] ??
            '', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: APIs.auth.currentUser!.uid,
        userName: APIs.auth.currentUser!.displayName.toString(),
        callID: callID,

        // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        // ..onOnlySelfInRoom = () => Navigator.of(context).pop(),
        );
  }
}
