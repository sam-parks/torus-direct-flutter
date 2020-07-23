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
  dynamic _torusLoginInfo = "Waiting...";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Torus Direct example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                  child: Text("Trigger Torus Login"),
                  onPressed: () async {
                    _torusLoginInfo = await torusDirect.triggerLogin();
                    setState(() {});
                  }),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text('Set Torus Options'),
                    onPressed: () async {
                      await torusDirect.setOptions(
                          VerifierType.singleLogin.key,
                          "tokenizer-google-ios",
                          "653095671042-san67chucuujmjoo218khq2rb92bh80d.apps.googleusercontent.com",
                          LoginProvider.google.key,
                          "tokenizer-google-ios",
                          "com.googleusercontent.apps.653095671042-san67chucuujmjoo218khq2rb92bh80d:/oauthredirect");
                    },
                  )),
              Text(_torusLoginInfo)
            ],
          ),
        ),
      ),
    );
  }
}
