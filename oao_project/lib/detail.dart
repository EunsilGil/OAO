import 'edit.dart';
import 'product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'global.dart';

class Detail extends StatefulWidget {

  final String documentID;

  const Detail({Key key, this.documentID}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {

  bool _isFetched = false;
  Product _product = Product();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _delete() async {
    await Firestore.instance.collection('products')
    .document(widget.documentID)
    .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Detail'),
        actions: <Widget>[

        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance.collection('products').document(widget.documentID).get(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
          Product product = Product.fromSnapshot(snapshot.data);
          _product = product;
          _isFetched = true;
          return Column(
            children: [
              Container(
                width: 100.0,
                height: 150.0,
                child: Image.network(product.image)
              ),
              Text(
                'category: ' + product.category,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'name: ' + product.product_name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
                )
              ),
              Text(
                'price: \$ '+product.price.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
                )
              ),
              SizedBox(width: double.infinity, height: 2.0),
              Text(
                'information: ' + product.site_name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
                )
              ),
              SizedBox(height: 10.0,),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      onPressed: () async {
                        QuerySnapshot q = await Firestore.instance
                          .collection('products')
                          .document(product.documentID)
                          .collection('up')
                          .where('flag',isEqualTo: true)
                          .getDocuments();
                        if(q.documents.where((snapshot) => snapshot.documentID==Global.currentUser.uid).isNotEmpty){
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            duration: const Duration(milliseconds: 1000),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('You can do only it once!!'),
                                FlatButton(
                                  child: Text('Undo'),
                                  onPressed: () async {
                                    await Firestore.instance.collection('products')
                                      .document(product.documentID)
                                      .collection('up')
                                      .document(Global.currentUser.uid)
                                      .updateData({'flag': false});
                                  },
                                )
                              ],
                            ),
                          ));
                        } else {
                          await Firestore.instance
                            .collection('products')
                            .document(product.documentID)
                            .collection('up').document(Global.currentUser.uid).setData({
                              'flag': true
                            });
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            duration: const Duration(milliseconds: 1000),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('I like it!!'),
                                FlatButton(
                                  child: Text('Undo'),
                                  onPressed: () async {
                                    await Firestore.instance.collection('products')
                                      .document(product.documentID)
                                      .collection('up')
                                      .document(Global.currentUser.uid)
                                      .updateData({'flag': false});
                                  },
                                )
                              ],
                            ),
                          ));
                        }
                      },
                    ),
                    StreamBuilder(
                      stream: Firestore.instance
                        .collection('products')
                        .document(product.documentID)
                        .collection('up')
                        .where('flag', isEqualTo: true)
                        .snapshots(),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          return Text(snapshot.data.documents.length.toString());
                        }
                        return Container();
                      }
                    )
                  ],
                ),
              )
            ],
          );
        }
      ),
    );
  }
}