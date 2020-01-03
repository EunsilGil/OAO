import 'dart:io';

import 'global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Add extends StatefulWidget {

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {

  TextEditingController categoryController;
  TextEditingController nameController;
  TextEditingController priceController;
  TextEditingController informationController;

  bool _isFirst = true;
  File _image;

  @override
  void initState() {
    super.initState();
    categoryController = TextEditingController();
    nameController = TextEditingController();
    priceController = TextEditingController();
    informationController = TextEditingController();
  }

  @override
  void dispose() {
    categoryController.dispose();
    nameController.dispose();
    priceController.dispose();
    informationController.dispose();
    super.dispose();
  }

  Future<File> _getImage() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<String> _uploadImageGetUrl(File image, String fileName) async {
    StorageReference ref = Global.storage.ref().child(fileName);
    StorageUploadTask uploadTask = ref.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _update() async {
    String imageUrl = _isFirst ? Global.defaultImage :
     await _uploadImageGetUrl(_image, nameController.text);
     DateTime now = DateTime.now();
    await Firestore.instance.collection('products')
      .document(nameController.text)
      .setData({
        'name': nameController.text,
        'category': categoryController.text,
        'information': informationController.text,
        'price': int.parse(priceController.text),
        'image': imageUrl,
        'modified': now,
        'created': now,
        'creator': Global.currentUser.uid
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add'),
        centerTitle: true,
        leading: FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop()
        ),
        actions: [
          FlatButton(
            child: Text('Save'),
            onPressed: () async {
              await _update();
              Navigator.of(context).pop();
            }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 200.0,
              height: 250.0,
              child: _isFirst ? Image.network(Global.defaultImage)
                : Image.file(_image),
            ),
            SizedBox(height: 10.0),
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () async {
                _image = await _getImage();
                _isFirst = false;
                setState(() {});
              },
            ),
            SizedBox(height: 10.0),
            TextField(controller: categoryController,decoration: InputDecoration(
              hintText: 'Category'
            ),),
            SizedBox(height: 10.0),
            TextField(controller: nameController,decoration: InputDecoration(
              hintText: 'Name'
            )),
            SizedBox(height: 10.0),
            TextField(controller: priceController,decoration: InputDecoration(
              hintText: 'Price'
            )),
            SizedBox(height: 10.0),
            TextField(controller: informationController,decoration: InputDecoration(
              hintText: 'Information'
            ))
          ],
        ),
      )
    );
  }
}