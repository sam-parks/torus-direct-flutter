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
  dynamic _torusLoginInfo = "Waiting for Torus Login Info...";

  @override
  void initState() {
    super.initState();
    TorusDirect.setOptions(
        VerifierType.singleLogin.value,
        "tokenizer-google-ios",
        "653095671042-san67chucuujmjoo218khq2rb92bh80d.apps.googleusercontent.com",
        LoginProvider.google.value,
        "tokenizer-google-ios",
        "com.googleusercontent.apps.653095671042-san67chucuujmjoo218khq2rb92bh80d:/oauthredirect");
  }

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
              RaisedButton(
                  child: Text("Trigger Torus Login"),
                  onPressed: () async {
                    _torusLoginInfo = await TorusDirect.triggerLogin();
                    setState(() {});
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_torusLoginInfo),
              )
            ],
          ),
        ),
      ),
    );
  }
}
