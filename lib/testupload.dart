import 'dart:html' as html;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

class TestUpload extends StatefulWidget {
  const TestUpload({Key key}) : super(key: key);

  @override
  _TestUploadState createState() => _TestUploadState();
}

class _TestUploadState extends State<TestUpload> {

  PlatformFile image ;

  Future _imagePicker() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }

      var sizeimage = await image.length();
      var iamgebyte =await image.readAsBytes();

      var imageTemporary = PlatformFile(path:image.path,name: image.name, size: sizeimage,bytes: iamgebyte,readStream: image.readAsBytes().asStream());

      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ElevatedButton(
          child: Text('Upload'),
          onPressed: () async {

             await _imagePicker();

            var iamge =  await AllApi().setImageVendor(image);

            print('suceess $iamge');

          },
        ),
      ),
    );
  }
}
