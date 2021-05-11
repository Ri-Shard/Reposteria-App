import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final String addressId;
  final double totalAmount;

  PaymentPage({Key key, this.addressId,this.totalAmount}): super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}




class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Material
    (
      child: Container(
        color: Colors.pink,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset("images/On_way.png")
              ),
              SizedBox(height: 10.0,),
              FlatButton(
                color: Colors.pinkAccent,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.deepOrange,
                onPressed: () => addOrderDetails(),
                child: Text("Realizar el pedido",style: TextStyle(fontSize:30.0),),
              )
            ],
          ),
        ),
      ),
    );
  }

  addOrderDetails()
  {
    writeOrderDetailsForUser({
      ReposteriaApp.addressID: widget.addressId,
      ReposteriaApp.totalAmount:widget.totalAmount,
      "OrderBy" : ReposteriaApp.sharedPreferences.getStringList(ReposteriaApp.userCartList),
      ReposteriaApp.paymentDetails: "Pago Contraentrega",
      ReposteriaApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      ReposteriaApp.isSuccess: true,
    });

      writeOrderDetailsForAdmin({
      ReposteriaApp.addressID: widget.addressId,
      ReposteriaApp.totalAmount:widget.totalAmount,
      "OrderBy" : ReposteriaApp.sharedPreferences.getString(ReposteriaApp.userUID),
      ReposteriaApp.paymentDetails: "Pago Contraentrega",
      ReposteriaApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      ReposteriaApp.isSuccess: true,
    }).whenComplete(() => {
      emptyCartNow()
    });
  }

  emptyCartNow()
  {
     ReposteriaApp.sharedPreferences.setStringList(ReposteriaApp.userCartList, ["garbageValue"]);
     List tempList = ReposteriaApp.sharedPreferences.getStringList(ReposteriaApp.userCartList);

     Firestore.instance.collection("users")
     .document(ReposteriaApp.sharedPreferences.getString(ReposteriaApp.userUID))
     .updateData({
       ReposteriaApp.userCartList: tempList,
     }).then((value) => {
       ReposteriaApp.sharedPreferences.setStringList(ReposteriaApp.userCartList,tempList),
       Provider.of<CartItemCounter>(context,listen: false).displayResult(),
     });
     Fluttertoast.showToast(msg: "Su orden ha sido puesta Satisfactoriamente") ;
      Route route = MaterialPageRoute (builder: (c) => SplashScreen());
       Navigator.pushReplacement(context, route);
  }
  Future writeOrderDetailsForUser(Map<String,dynamic> data) async
  {
    await ReposteriaApp.firestore.collection(ReposteriaApp.collectionUser)
    .document(ReposteriaApp.sharedPreferences.getString(ReposteriaApp.userUID)).collection(ReposteriaApp.collectionOrders)
    .document(ReposteriaApp.sharedPreferences.getString(ReposteriaApp.userUID) + data['orderTime']).setData(data);
  }
  Future writeOrderDetailsForAdmin(Map<String,dynamic> data) async
  {
    await ReposteriaApp.firestore
    .collection(ReposteriaApp.collectionOrders)
    .document(ReposteriaApp.sharedPreferences.getString(ReposteriaApp.userUID) + data['orderTime']).setData(data);
  }
}
