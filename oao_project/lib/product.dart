import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String site_name;
  String image;
  String product_name;
  String category;
  String documentID;
  int price;
  String URL;

  Product();

  Product.fromSnapshot(DocumentSnapshot snapshot) {
    site_name = snapshot.data['site_name'];
    image = snapshot.data['image'];
    product_name = snapshot.data['product_name'];
    category = snapshot.data['category'];
    documentID = snapshot.documentID;
    price = snapshot.data['price'];
    URL = snapshot.data['URL'];
  }
}