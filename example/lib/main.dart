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
  TorusDirect torusDirect = TorusDirect();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Torus Direct example app'),
        ),
        body: Center(
          child: RaisedButton(
              child: Text("Trigger Torus Login"),
              onPressed: () async {
                await torusDirect.triggerLogin();
              }),
        ),
      ),
    );
  }
}
