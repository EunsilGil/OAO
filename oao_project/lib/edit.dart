import 'dart:io';

import 'global.dart';
import 'product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Edit extends StatefulWidget {

  final Product product;

  const Edit({Key key, this.product}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {

  TextEditingController categoryController;
  TextEditingController nameController;
  TextEditingController priceController;
  TextEditingController informationController;

  bool _isFirst = true;
  File _image;

  @override
  void initState() {
    super.initState();
    categoryController = TextEditingController(text: widget.product.category);
    nameController = TextEditingController(text: widget.product.product_name);
    priceController = TextEditingController(text: widget.product.price.toString());
    informationController = TextEditingController(text: widget.product.site_name);
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
    String imageUrl = _isFirst ? widget.product.image :
     await _uploadImageGetUrl(_image, nameController.text);
    await Firestore.instance.collection('products')
      .document(widget.product.documentID)
      .updateData({
        'name': nameController.text,
        'category': categoryController.text,
        'information': informationController.text,
        'price': int.parse(priceController.text),
        'image': imageUrl,
        'modified': FieldValue.serverTimestamp()
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
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
              child: _isFirst ? Image.network(widget.product.image)
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
            TextField(controller: categoryController),
            SizedBox(height: 10.0),
            TextField(controller: nameController),
            SizedBox(height: 10.0),
            TextField(controller: priceController),
            SizedBox(height: 10.0),
            TextField(controller: informationController)
          ],
        ),
      )
    );
  }
}