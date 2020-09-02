import 'package:flutter/material.dart';
import 'package:sqflite_demo/database_helper.dart';

TextEditingController nameController = new TextEditingController();

String name;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sqflite Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => insertForm()));
              },
              child: Text('Insert'),
            ),
            RaisedButton(
              onPressed: () async {
                List<Map<String, dynamic>> queryrows =
                    await DatabaseHelper.instance.queryAll();
                print(queryrows);
              },
              child: Text('Query'),
            ),
            RaisedButton(
              onPressed: () async {
                int updatedId = await DatabaseHelper.instance.update({
                  DatabaseHelper.columnID: 2,
                  DatabaseHelper.columnName: 'AN'
                });
                print(updatedId);
              },
              child: Text('Update'),
            ),
            RaisedButton(
              onPressed: () async {
                int rowsaffected = await DatabaseHelper.instance.delete(3);
                print(rowsaffected);
              },
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}

class insertForm extends StatefulWidget {
  @override
  _insertFormState createState() => _insertFormState();
}

class _insertFormState extends State<insertForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Insert Data'),
        ),
        body: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your Name',
                    labelText: 'Name',
                  ),
                  onSaved: (String value) {},
                  validator: (String value) {
                    return (value.isEmpty) ? 'Enter your name' : null;
                  },
                ),
                RaisedButton(
                    child: Text('Submit'),
                    onPressed: () async {
                      print(nameController.text);
                      if (_formKey.currentState.validate()) {
                        int i = await DatabaseHelper.instance.insert(
                            {DatabaseHelper.columnName: nameController.text});
                        print('Inserted id is $i');
                        Navigator.of(context).pop();
                      }
                    }),
              ],
            )));
//    );
  }
}
