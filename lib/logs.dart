import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '/http_service.dart';
import '/nav.dart';

import 'log_model.dart';

class LogsPage extends StatelessWidget {
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
        appBar: AppBar(title: const Text("Logs")),
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
            future: httpService.getLog(),
            builder: (BuildContext context, AsyncSnapshot<List<Log>> snapshot) {
              if (snapshot.hasData) {
                List<Log>? logs = snapshot.data;
                return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                        child: ListView(
                      children: logs!
                          .map(
                            (Log log) => ListTile(
                              title: Text(log.lock_name),
                              subtitle: log.status
                                  ? Text("Locked by " + log.changed_by)
                                  : Text("Unlocked by " + log.changed_by),
                              tileColor: !log.status
                                  ? Colors.greenAccent.shade100
                                  : Colors.redAccent.shade100,
                              trailing: Text(DateFormat('MMM dd yyyy hh:mm a')
                                  .format(log.date)),
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
