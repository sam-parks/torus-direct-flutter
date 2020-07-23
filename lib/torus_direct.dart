library torus_direct;

import 'package:flutter/services.dart';

class TorusDirect {
  static const _channel = const MethodChannel('torus.flutter.dev/torus-direct');

  static Future<void> setOptions(String verifierType, String verifierName,
      String clientId, String loginProvider, String verifier, String redirectURL) async {
    try {
      await _channel.invokeMethod('setOptions', {
        "verifierType": verifierType,
        "verifierName": verifierName,
        "clientId": clientId,
        "loginProvider": loginProvider,
        "verifier": verifier,
        "redirectURL": redirectURL
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  static Future<dynamic> triggerLogin() async {
    try {
      return await _channel.invokeMethod('triggerLogin');
    } on PlatformException catch (e) {
      print(e);
    }
  }
}

enum VerifierType {
  singleLogin,
  singleIdVerifier,
  andAggregateVerifier,
  orAggregateVerifier
}

enum LoginProvider { google, facebook, twitch, reddit, discord, auth0 }

extension VerifierExtension on VerifierType {
  String get key {
    switch (this) {
      case VerifierType.singleLogin:
        return "single_login";
        break;
      case VerifierType.singleIdVerifier:
        return "single_id_verifier";
        break;
      case VerifierType.andAggregateVerifier:
        return "and_aggregate_verifier";
        break;
      case VerifierType.orAggregateVerifier:
        return "or_aggregate_verifier";
        break;
      default:
        return "single_login";
    }
  }
}

extension LoginProviderExtension on LoginProvider {
  String get key {
    switch (this) {
      case LoginProvider.google:
        return "google";
        break;
      case LoginProvider.facebook:
        return "facebook";
        break;
      case LoginProvider.twitch:
        return "twitch";
        break;
      case LoginProvider.reddit:
        return "reddit";
        break;
      case LoginProvider.discord:
        return "discord";
        break;
      case LoginProvider.auth0:
        return "auth0";
        break;
      default:
        return "google";
    }
  }
}
