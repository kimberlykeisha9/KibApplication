import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import 'authorization.dart';
import 'employee.dart';
import 'style.dart';

class ID extends StatefulWidget {
  const ID({Key? key}) : super(key: key);

  @override
  _IDState createState() => _IDState();
}

class _IDState extends State<ID> {
  File? idImage;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SvgPicture.asset(
                    'assets/Logo.svg',
                    color: Theme.of(context).primaryColor,
                    height: 35,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  'Register',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Text(
                  'Proof of Identity',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Text(
                  'Kib requires a document that gives proof of identity. If you would like to know more about how we handle your information, please read our privacy policy.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Text(
                  'Please upload your Kenyan National ID or National Passport.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Container(
                width: width,
                height: height * 0.3,
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.5,
                    color: const Color(0xFF134545),
                  ),
                ),
                child: idImage == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final XFile? _image = await _picker.pickImage(source: ImageSource.camera);
                                      if (_image != null) {
                                        setState(
                                          () => idImage = File(_image.path),
                                        );
                                      }
                                    },
                                    child: const Icon(
                                      Icons.camera,
                                      size: 40,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Take a picture',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(
                              'Change ID Image',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            content: Text(
                              'Are you sure you want to change your ID image?',
                            ),
                            actions: [
                              TextButton(
                                child: Text('Yes'),
                                onPressed: () {
                                  setState(() => idImage = null);
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                        child: Image.file(idImage!, fit: BoxFit.cover),
                      ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    width: width,
                    child: ElevatedButton(
                        child: const Text('NEXT'),
                        onPressed: () => {
                              if (idImage != null)
                                Employee().uploadId(idImage!).then((value) => Navigator.pushNamed(context, 'Await Verification'))
                              else
                                showSnackbar(context, 'Please take a picture of your ID')
                            }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
