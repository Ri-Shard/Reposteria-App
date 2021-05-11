import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/common/colors.dart';
import 'package:e_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String getOrderId="";
class OrderDetails extends StatelessWidget {

final String orderId;

OrderDetails({Key key, this.orderId}):super(key:key);
  @override
  Widget build(BuildContext context) {

    getOrderId = orderId;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: ReposteriaApp.firestore
                   .collection(ReposteriaApp.collectionUser)
                   .document(ReposteriaApp.sharedPreferences.getString(ReposteriaApp.userUID))
                   .collection(ReposteriaApp.collectionOrders)
                   .document(orderId)
                   .get(),

                   builder: (c,snapshot)
                   {
                     Map dataMap;
                     if(snapshot.hasData)
                     {
                       dataMap=snapshot.data.data;
                     }
                     return snapshot.hasData
                          ?Container(
                            child: Column(
                              children: [
                                StatusBanner(status: dataMap[ReposteriaApp.isSuccess]),
                                SizedBox(height:10.0),
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      r"$" + dataMap[ReposteriaApp.totalAmount].toString(),
                                      style: TextStyle(fontSize: 20.0, fontWeight:FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:EdgeInsets.all(4.0),
                                  child:Text(
                                    "Id Pedido: "+getOrderId
                                  ),                                
                                ),
                                Padding(
                                  padding:EdgeInsets.all(4.0),
                                  child:Text(
                                    "Fecha de pedido: "+DateFormat("dd MMMM,yyyy - hh:mm aa")
                                    .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"]))),
                                    style: TextStyle(color: Colors.grey, fontSize:16.0),
                                  ),                                   
                                ),
                                Divider(height: 2.0,),
                                FutureBuilder<QuerySnapshot>(
                                  future: ReposteriaApp.firestore
                                  .collection("items")
                                  .where("shortInfo",whereIn: dataMap[ReposteriaApp.productID])
                                  .getDocuments(),

                                  builder: (c, dataSnapshot)
                                  {
                                    return dataSnapshot.hasData
                                          ? OrderCard(
                                            itemCount: dataSnapshot.data.documents.length,
                                            data: dataSnapshot.data.documents,
                                          )
                                         :Center(child: circularProgress(),);
                                  },
                                ),
                                Divider(height: 2.0,),
                                FutureBuilder<DocumentSnapshot>(
                                   future: ReposteriaApp.firestore
                                  .collection(ReposteriaApp.collectionUser)
                                  .document(ReposteriaApp.sharedPreferences.getString(ReposteriaApp.userUID))
                                  .collection(ReposteriaApp.subCollectionAddress)
                                  .document(dataMap[ReposteriaApp.addressID])
                                  .get(),
                                  builder: (c,snap)
                                  {
                                    return snap.hasData
                                          ?ShippingDetails(model: AddressModel.fromJson(snap.data.data))
                                          :Center(child: circularProgress(),);

                                  }
                                )

                              ],
                            ),
                          )
                          :Center(child: circularProgress(),);
                          }
          ),
        ),
      ),
    );
  }
}



class StatusBanner extends StatelessWidget {

  final bool status;
  StatusBanner({Key key, this.status}):super(key: key);
  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Completado" : msg = "Sin completar";

    return Container(
      color: Colors.pink,
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              SystemNavigator.pop();
            },
            child: Container(
              child: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 20.0,),
          Text(
            "Pedido Realizado" + msg,
            style: TextStyle(color:kCategorypinkColor),
          ),
          SizedBox(width: 5.0),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
              ),
            ),

          )
        ],
      ),
    );
  }
}



class ShippingDetails extends StatelessWidget {
  
  final AddressModel model;
  ShippingDetails({Key key,this.model}):super(key: key);  
  @override
  Widget build(BuildContext context) {
    
    double screenwidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height : 20.0),
        Padding(
          padding:EdgeInsets.symmetric(horizontal:90.0, vertical: 5.0),
          child: Text(
            "Detalles de Envio: ",
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)
          )
        ),
            Container(
            padding:EdgeInsets.symmetric(horizontal:90.0, vertical: 5.0),
          width: screenwidth,
          child: Table(
            children: [
              TableRow(
                children: [
                    KeyText(
                      msg: "Nombre",
                    ),
                    Text(model.name),
                ]
              ),
              TableRow(
                children: [
                    KeyText(
                      msg: "Numero de Telefono",
                    ),
                    Text(model.phoneNumber),
                ]
              ),
              TableRow(
                children: [
                    KeyText(
                      msg: "Direccion",
                    ),
                    Text(model.flatNumber),
                ]
              ),
              TableRow(
                children: [
                    KeyText(
                      msg: "Ciudad",
                    ),
                    Text(model.city),
                ]
              ),
              TableRow(
                children: [
                    KeyText(
                      msg: "Departamento",
                    ),
                    Text(model.state),
                ]
              ),
            ]
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: ()
              {
                confirmedUserOrderReceived(context,getOrderId);
                              },
                              child: Container(
                                color: Colors.pink,
                                width: MediaQuery.of(context).size.width-40.0,
                                height: 50.0,
                                child: Center(
                                  child: Text(
                                    "Pedidos confirmados recibidos",
                                    style: TextStyle(color: Colors.white, fontSize: 15.0 ),
                                  ),  
                                  ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }
                
                 confirmedUserOrderReceived(BuildContext context, String mOrderId) 
                 {
                   ReposteriaApp.firestore
                   .collection(ReposteriaApp.collectionUser)
                   .document(ReposteriaApp.sharedPreferences.getString(ReposteriaApp.userUID))
                   .collection(ReposteriaApp.collectionOrders)
                   .document(mOrderId)
                   .delete();

                   getOrderId = "";
                   Route route = MaterialPageRoute(builder: (c) => SplashScreen());
                   Navigator.pushReplacement(context, route);

                   Fluttertoast.showToast(msg: "El pedido ha sido Recibido");
                 }
}


