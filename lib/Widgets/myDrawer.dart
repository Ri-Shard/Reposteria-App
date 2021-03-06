import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0,bottom: 10.0),
            color: Colors.pink,
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  elevation: 8.0,
                  child: Container(
                    height: 160.0,
                    width:160.0,
                    child: CircleAvatar(
                    backgroundColor: Colors.pink,
                    backgroundImage: (
                    AssetImage('images/male_avatar.png')
                  )                      
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                Text(
                 ReposteriaApp.sharedPreferences.getString(ReposteriaApp.userName),
                 style: TextStyle(color: Colors.white,fontSize: 35.0,fontFamily: "Signatra"),
                )
              ],
              ),
          ),
          SizedBox(height: 12.0),
          Container(
            padding: EdgeInsets.only(top:1.0),
            color: Colors.pink,
            child: Column(
                children: [
                ListTile(
                leading: Icon(Icons.home,color: Colors.white),
                title: Text("Inicio",style: TextStyle(color: Colors.white),),
                onTap: () {
                  Route route = MaterialPageRoute (builder: (c) => StoreHome());
                  Navigator.push(context, route); 
                } ,
                ),
                Divider(height: 10.0,color: Colors.white,thickness: 6.0),

                ListTile(
                leading: Icon(Icons.reorder,color: Colors.white),
                title: Text("Mis Ordenes",style: TextStyle(color: Colors.white),),
                onTap: () {
                  Route route = MaterialPageRoute (builder: (c) => MyOrders());
                  Navigator.push(context, route); 
                } ,
                ),
                Divider(height: 10.0,color: Colors.white,thickness: 6.0),

                ListTile(
                leading: Icon(Icons.shopping_cart,color: Colors.white),
                title: Text("Mi carrito",style: TextStyle(color: Colors.white),),
                onTap: () {
                  Route route = MaterialPageRoute (builder: (c) => CartPage());
                  Navigator.push(context, route); 
                } ,
                ),
                Divider(height: 10.0,color: Colors.white,thickness: 6.0),

                  ListTile(
                leading: Icon(Icons.search,color: Colors.white),
                title: Text("Buscar",style: TextStyle(color: Colors.white),),
                onTap: () {
                  Route route = MaterialPageRoute (builder: (c) => SearchProduct());
                  Navigator.push(context, route); 
                } ,
                ),
                Divider(height: 10.0,color: Colors.white,thickness: 6.0),

                  ListTile(
                leading: Icon(Icons.add_location,color: Colors.white),
                title: Text("A??adir nueva Direccion",style: TextStyle(color: Colors.white),),
                onTap: () {
                  Route route = MaterialPageRoute (builder: (c) => AddAddress());
                  Navigator.push(context, route); 
                } ,
                ),
                Divider(height: 10.0,color: Colors.white,thickness: 6.0),

                  ListTile(
                leading: Icon(Icons.exit_to_app,color: Colors.white),
                title: Text("Cerrar Sesion",style: TextStyle(color: Colors.white),),
                onTap: () {
                  ReposteriaApp.auth.signOut().then((c){
                  Route route = MaterialPageRoute (builder: (c) => AuthenticScreen());
                  Navigator.pushReplacement(context, route); 
                  });
                } ,
                ),
                Divider(height: 10.0,color: Colors.white,thickness: 6.0),   
                ],

            ),
             ),
        ],
      ),
    );
  }
}
