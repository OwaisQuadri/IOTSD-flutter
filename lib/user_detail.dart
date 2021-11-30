import 'package:flutter/material.dart';
import 'package:flutter_demo/http_service.dart';
import 'package:flutter_demo/user_model.dart';
import 'package:flutter_demo/users.dart';

class UserDetail extends StatelessWidget {
  final User user;
  final HttpService httpService = HttpService();

  UserDetail({required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.delete),
        onPressed: () async {
          httpService.deleteUser(user.name);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UsersPage(),
          ));
        },
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: const Text("Name"),
                  subtitle: Text(user.name),
                ),
                ListTile(
                  title: const Text("Phone Number"),
                  subtitle: Text(user.phone),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
