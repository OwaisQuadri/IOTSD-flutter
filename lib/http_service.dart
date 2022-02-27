// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:convert';
import '/user_model.dart';
import 'package:http/http.dart';
import 'package:image/image.dart' as Im;
import 'lock_model.dart';
import 'log_model.dart';

class HttpService {
  final String url = 'https://validation--api.herokuapp.com';
  final headers = {"Authorization": "Basic YWRtaW46Q2Fwc3RvbmUtR3JvdXAtMjk="};
  final postHeaders = {
    "Authorization": "Basic YWRtaW46Q2Fwc3RvbmUtR3JvdXAtMjk=",
    'Content-Type': 'application/json'
  };
  Future<List<User>> getUsers() async {
    Response res = await get(Uri.parse(url), headers: headers);
    if (res.statusCode == 200) {
      //success
      List<dynamic> body = jsonDecode(res.body);
      List<User> users =
          body.map((dynamic item) => User.fromJson(item)).toList();
      return users;
    } else if (res.statusCode == 403) {
      throw "Authentication error";
    } else {
      throw "Can't get users";
    }
  }

  Future<void> deleteUser(String name) async {
    Response res = await get(Uri.parse("$url/delete/$name"), headers: headers);
    if (res.statusCode == 204) {
      //success
      // ignore: avoid_print
      print("Deleted");
    } else if (res.statusCode == 403) {
      throw "Authentication error";
    } else {
      throw "Can't get user to delete";
    }
  }

  void createUser({required name, required faceImage, required phone}) async {
    final image = Im.decodeImage(File(faceImage.path).readAsBytesSync());
    final newImageName = name + '.png';
    File(newImageName).writeAsBytesSync(Im.encodePng(image!));

    List<int> imageBytes = File(newImageName.path).readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    Map data = {
      'name': name,
      'known': true,
      'phone': phone,
      'face': base64Image
    };
    var createUserBody = json.encode(data);
    print(createUserBody);
    Response res =
        await post(Uri.parse(url), headers: postHeaders, body: createUserBody);
    if (res.statusCode == 201) {
      //success
    } else if (res.statusCode == 403) {
      throw "Authentication error";
    } else if (res.statusCode == 500) {
      throw "Internal Error";
    } else {
      throw "Can't create users";
    }
  }

  Future<List<Lock>> getLocks() async {
    Response res = await get(Uri.parse('$url/status/'), headers: headers);
    if (res.statusCode == 200) {
      //success
      List<dynamic> body = jsonDecode(res.body);
      List<Lock> locks =
          body.map((dynamic item) => Lock.fromJson(item)).toList();
      return locks;
    } else if (res.statusCode == 403) {
      throw "Authentication error";
    } else {
      throw "Can't get users";
    }
  }

  Future<List<Log>> getLog() async {
    Response res = await get(Uri.parse('$url/status/logs/'), headers: headers);
    if (res.statusCode == 200) {
      //success
      List<dynamic> body = jsonDecode(res.body);
      List<Log> logs = body.map((dynamic item) => Log.fromJson(item)).toList();
      return logs;
    } else if (res.statusCode == 403) {
      throw "Authentication error";
    } else {
      throw "Can't get logs";
    }
  }

  toggle(Lock lock) async {
    var status = lock.status ? false : true;

    Map data = {
      'lock_name': lock.lock_name,
      'status': status,
      'changed_by': 'admin',
    };
    var setStatusBody = json.encode(data);
    Response res = await post(Uri.parse('$url/status/'),
        headers: postHeaders, body: setStatusBody);
    if (res.statusCode == 201) {
      //success
      print("Lock Toggled");
    } else if (res.statusCode == 403) {
      throw "Authentication error";
    } else if (res.statusCode == 500) {
      throw "Internal Error";
    } else {
      throw "Can't create users";
    }
  }
}
