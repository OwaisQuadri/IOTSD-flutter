import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '/create_user.dart';
import '/http_service.dart';
import '/nav.dart';
import '/user_detail.dart';
import '/user_model.dart';

class UsersPage extends StatelessWidget {
  final HttpService httpService = HttpService();
  refresh(context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (a, b, c) => Nav(),
        transitionDuration: const Duration(seconds: 0),
      ),
    );
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Users")),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20),
          child: FloatingActionButton(
            child: const Icon(Icons.person_add),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateUserPage(),
            )),
            backgroundColor: Colors.blue,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (a, b, c) => Nav(),
                transitionDuration: const Duration(seconds: 0),
              ),
            );
            return Future.value(false);
          },
          child: FutureBuilder(
            future: httpService.getUsers(),
            builder:
                (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
              if (snapshot.hasData) {
                List<User>? users = snapshot.data;
                return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                        child: ListView(
                      children: users!
                          .map(
                            (User user) => ListTile(
                              title: Text(user.name),
                              subtitle: Text(user.phone),
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UserDetail(user: user),
                              )),
                            ),
                          )
                          .toList(),
                    )));
              }
              // ignore: prefer_const_constructors
              return Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}
