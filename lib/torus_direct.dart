library torus_direct;

import 'package:flutter/services.dart';

class TorusDirect {
  static const _channel = const MethodChannel('torus.flutter.dev/torus-direct');

  Future<void> init(String verifierType, String verifierName, String clientId,
      String typeOfLogin, String verifier) async {
    try {
      await _channel.invokeMethod('init', {
        "veriferType": verifierType,
        "verifierName": verifierName,
        "clientId": clientId,
        "typeOfLogin": typeOfLogin,
        "verifier": verifier
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<dynamic> triggerLogin() async {
    try {
      return await _channel.invokeMethod('triggerLogin');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
