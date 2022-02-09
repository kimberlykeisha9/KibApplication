import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kib/employer.dart';
import 'style.dart';

class ID extends StatefulWidget {
  const ID({Key? key}) : super(key: key);

  @override
  _IDState createState() => _IDState();
}

class _IDState extends State<ID> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? idImage;

  @override
  void dispose() {
    super.dispose();
    idImage = null;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // Timer function for time left
    return SizedBox(
      width: width,
      height: height,
      child: Form(
        key: _formKey,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        iconSize: 27,
                        padding: const EdgeInsets.all(0),
                        icon: Icon(
                          Icons.arrow_back_sharp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () => Navigator.pop(context),
                        alignment: Alignment.centerLeft,
                      ),
                      Hero(
                        tag: 'logo',
                        child: SvgPicture.asset(
                          'assets/Logo.svg',
                          color: Theme.of(context).colorScheme.primary,
                          width: 27,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 40),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Create an account',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Proof of identity',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Text(
                    'Kib requires a document that provides proof of identity. If you would like to learn more about how we handle your information, please read our Privacy Policy.',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      'Please upload a clear picture of your Kenyan National ID or National Passport to the space below.',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: width,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 2),
                    ),
                    // ignore: unnecessary_null_comparison
                    child: idImage == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(25),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        IconButton(
                                          icon: const Icon(
                                            Icons.photo_camera,
                                            size: 30,
                                          ),
                                          onPressed: () async {
                                            final XFile? _image = await _picker.pickImage(source: ImageSource.camera);
                                            if (_image != null) {
                                              setState(() => idImage = File(_image.path));
                                            }
                                          },
                                        ),
                                        Text(
                                          'Take a Picture',
                                          style: Theme.of(context).textTheme.bodyText1,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ])
                        : GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'Change ID Image',
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                content: Text(
                                  'Are you sure you want to change this image?',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      'Change',
                                    ),
                                    onPressed: () => {
                                      setState(() => idImage = null),
                                      Navigator.of(context).pop(),
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Cancel',
                                    ),
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
                                ],
                              ),
                            ),
                            child: Image.file(
                              idImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 10),
                          width: width,
                          child: ElevatedButton(
                            onPressed: () => idImage != null
                                ? Employer().uploadId(idImage!).then(
                                      (value) => Navigator.pushNamed(context, 'Await Verification'),
                                    )
                                : showSnackbar(
                                    context,
                                    'Please upload an identification document to proceed',
                                  ),
                            child: Text(
                              'Next',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
