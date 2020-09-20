library torus_direct;

import 'package:flutter/services.dart';

class TorusDirect {
  static const _channel = const MethodChannel('torus.flutter.dev/torus-direct');

  // Set your verifier options for your logins.

  static Future<bool> setOptions(
    DirectSdkArgs args,
    LoginProvider loginProvider,
    LoginType loginType,
    String verifier,
    String clientId,
  ) async {
    try {
      return await _channel.invokeMethod('setOptions', {
        "redirectUri": args.redirectUri,
        "proxyContractAddress": args.proxyContractAddress,
        "browserRedirectUri": args.browserRedirectUri,
        "network": args.network.value,
        "loginType": loginType.value,
        "verifier": verifier,
        "clientId": clientId,
        "loginProvider": loginProvider.value,
      });
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  // Trigger the Torus Login.
  static Future<Map<dynamic, dynamic>> triggerLogin() async {
    try {
      return await _channel.invokeMethod('triggerLogin');
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }
}

class DirectSdkArgs {
  String redirectUri;
  TorusNetwork network;
  String proxyContractAddress;
  String browserRedirectUri;

  DirectSdkArgs(this.redirectUri, this.network, this.proxyContractAddress,
      this.browserRedirectUri);
}

enum LoginType { web, installed }

enum LoginProvider { google, facebook, twitch, reddit, discord, auth0 }

extension LoginTypeExtension on LoginType {
  String get value {
    switch (this) {
      case LoginType.web:
        return "web";
        break;
      case LoginType.installed:
        return "installed";
        break;
      default:
        return "web";
    }
  }
}

enum TorusNetwork { MAINNET, TESTNET }

extension TestNetworkExtension on TorusNetwork {
  String get value {
    switch (this) {
      case TorusNetwork.MAINNET:
        return 'MAINNET';
        break;
      case TorusNetwork.TESTNET:
        return 'TESTNET';
        break;
      default:
        return 'TESTNET';
    }
  }
}

extension LoginProviderExtension on LoginProvider {
  String get value {
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
