import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encrypted Shared Preferences Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  String value = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    encryptedSharedPreferences.getString('sample').then((String _value) {
      setState(() {
        value = _value;
      });
    });
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encrypted Shared Preferences Demo Page'),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                    decoration:
                        InputDecoration(hintText: 'Type text here and save'),
                    controller: myController,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    }),
                Text('Current value: $value')
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            encryptedSharedPreferences
                .setString('sample', myController.text)
                .then((bool success) {
              if (success) {
                print('success');
                encryptedSharedPreferences
                    .getString('sample')
                    .then((String _value) {
                  setState(() {
                    value = _value;
                  });
                });
              } else {
                print('fail');
              }
            });
          }
        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }
}
