import 'package:flutter/material.dart';
import 'dart:async';
import 'package:torus_direct/torus_direct.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TorusDirect torusDirect = TorusDirect();

  @override
  void initState() {
    super.initState();
    initTorus();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initTorus() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await torusDirect.init(
          "single_id_verifier",
          "google-google",
          "238941746713-qqe4a7rduuk256d8oi5l0q34qtu9gpfg.apps.googleusercontent.com",
          "google",
          "google-shubs");
    } catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Torus Direct example app'),
        ),
        body: Center(
          child: MaterialButton(onPressed: () async {
            await torusDirect.triggerLogin();
          }),
        ),
      ),
    );
  }
}
