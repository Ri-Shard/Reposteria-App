import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}



class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.pink,
          centerTitle: true,
          title: Text("Mis Pedidos",style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(
              icon:  Icon(Icons.arrow_drop_down_circle,color: Colors.white),
              onPressed: ()
              {
                Navigator.pop(context);
              },
            ),
          ]
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: ReposteriaApp.firestore
          .collection(ReposteriaApp.collectionUser)
          .document(ReposteriaApp.sharedPreferences.getString(ReposteriaApp.userUID))
          .collection(ReposteriaApp.collectionOrders).snapshots(),
          
          builder: (c,snapshot)
          {
            return snapshot.hasData
                  ? ListView.builder(
                    itemCount:snapshot.data.documents.length,
                    itemBuilder: (c,index){
                      return FutureBuilder<QuerySnapshot>(
                        future: Firestore.instance.collection("items").where("shortInfo",whereIn: snapshot.data.documents[index].data[ReposteriaApp.productID])
                        .getDocuments(),

                        builder: (s, snap)
                        {
                          return snap.hasData
                                ? OrderCard(
                                  itemCount: snap.data.documents.length,
                                  data: snap.data.documents,
                                  orderId: snapshot.data.documents[index].documentID,
                                )
                                : Center(child: circularProgress(),);
                        },
                      );
                    }
                  )
                  :Center(child: circularProgress(),);
          }
        ),
      ),
    );
  }
}
