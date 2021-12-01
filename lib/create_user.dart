// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/http_service.dart';
import '/nav.dart';
import 'package:image_picker/image_picker.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({Key? key}) : super(key: key);

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final HttpService httpService = HttpService();
  String? _name;
  String? _phone;
  String? _face;
  XFile? _faceImage;
  final ImagePicker picker = ImagePicker();

  final GlobalKey<FormState> _createUserKey = GlobalKey<FormState>();

  Widget _buildName() => TextFormField(
        decoration: const InputDecoration(
          labelText: "Name",
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "enter your name";
          } else {
            return null;
          }
        },
        onChanged: (value) => setState(() {
          _name = value;
        }),
      );

  Widget _buildFace() => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
            ),
            child: const Text('Take Photo',
                style: TextStyle(
                    color: Color(0xffffffff),
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            onPressed: () async {
              XFile? image = await picker.pickImage(source: ImageSource.camera);
              setState(() {
                _faceImage = image;
              });
            }),
        const SizedBox(
          height: 20,
        ),
        _faceImage == null
            ? const SizedBox(
                height: 20,
              )
            : Image.file(File(_faceImage!.path)),
      ]));

  Widget _buildPhone() => TextFormField(
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          labelText: "Phone Number",
          hintText: "+1XXXXXXXXXX",
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.length != 12) {
            return "Invalid Phone Number";
          } else {
            if (value.substring(0, 2) == "+1") {
              return null;
            } else {
              return "Please start with +1";
            }
          }
        },
        onChanged: (value) => setState(() {
          _phone = value;
        }),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create User"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
              key: _createUserKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildName(),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildPhone(),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildFace(),
                ],
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          if (_createUserKey.currentState!.validate()) {
            httpService.createUser(
                name: _name, faceImage: _faceImage, phone: _phone);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Nav(),
            ));
            //httpService.createUser();
          }
        },
      ),
    );
  }
}
