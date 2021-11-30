import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '/http_service.dart';
import '/nav.dart';

import 'lock_model.dart';

class LocksPage extends StatelessWidget {
  final HttpService httpService = HttpService();
  refresh(context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (a, b, c) => Nav(),
        transitionDuration: const Duration(seconds: 0),
      ),
    );
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Locks (tap to toggle)")),
        body: RefreshIndicator(
          onRefresh: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (a, b, c) => Nav(),
                transitionDuration: const Duration(seconds: 0),
              ),
            );
            return Future.value(true);
          },
          child: FutureBuilder(
            future: httpService.getLocks(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Lock>> snapshot) {
              if (snapshot.hasData) {
                List<Lock>? locks = snapshot.data;
                return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                        child: ListView(
                      children: locks!
                          .map(
                            (Lock lock) => ListTile(
                              title: Text(lock.lock_name),
                              subtitle: lock.status
                                  ? Text("Locked")
                                  : Text("Unlocked"),
                              tileColor: !lock.status
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              onTap: () {
                                httpService.toggle(lock);
                                refresh(context);
                              },
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
