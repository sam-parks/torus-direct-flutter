import 'dart:io';

import 'package:flutter/material.dart';
import 'package:torus_direct/torus_direct.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  dynamic _torusLoginInfo;
  String _currentVerifier = "Google";
  String _privateKey = "Waiting for login...";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Torus Direct example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("Google Login"),
                  onPressed: _googleLogin,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("Facebook Login"),
                  onPressed: _facebookLogin,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("Reddit Login"),
                  onPressed: _redditLogin,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("Twitch Login"),
                  onPressed: _twitchLogin,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("Discord Login"),
                  onPressed: _discordLogin,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _currentVerifier + " key: " + _privateKey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _googleLogin() async {
   
    DirectSdkArgs args = DirectSdkArgs(
        "torusapp://org.torusresearch.torusdirectandroid/redirect",
        TorusNetwork.TESTNET,
        "0x4023d2a0D330bF11426B12C6144Cfb96B7fa6183",
        "torusapp://org.torusresearch.torusdirectandroid/redirect");

    bool success;
    if (Platform.isIOS) {
      success = await TorusDirect.setOptions(
        args,
        LoginProvider.google,
        LoginType.installed,
        "samtwo-google",
        "360801018673-1tmrfbvc2og29c8lmoljpl16ptkc20b3.apps.googleusercontent.com",
      );
    } else {
       print("Android google");
      success = await TorusDirect.setOptions(
        args,
        LoginProvider.google,
        LoginType.installed,
        "google-lrc",
        "221898609709-obfn3p63741l5333093430j3qeiinaa8.apps.googleusercontent.com",
      );
    }

    print(success);

    Map<dynamic, dynamic> _torusLoginInfo;
    _torusLoginInfo = await TorusDirect.triggerLogin();

    setState(() {
      _privateKey = _torusLoginInfo['privateKey'];
      _currentVerifier = "Google";
    });
  }

  _facebookLogin() async {}

  _twitchLogin() async {}

  _redditLogin() async {}

  _discordLogin() async {}
}
