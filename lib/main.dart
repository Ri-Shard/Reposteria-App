import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Counters/BookQuantity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'Authentication/authenication.dart';
import 'Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  ReposteriaApp.auth = FirebaseAuth.instance;
  ReposteriaApp.sharedPreferences = await SharedPreferences.getInstance();
  ReposteriaApp.firestore = Firestore.instance;


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            title: 'ReposteriaApp',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.pink,
            ),
            home: SplashScreen()
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen>
{
  @override
  void initState()
  {
    super.initState();
    displaySplash();
  }
  displaySplash()
  {
    Timer(Duration(seconds:5), () async {
      if(await ReposteriaApp.auth.currentUser() !=null)
      {
        Route route = MaterialPageRoute(builder: (_) =>StoreHome());
        Navigator.pushReplacement(context, route);
      }else{
         Route route = MaterialPageRoute(builder: (_) =>AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Color(0xFFFF9494),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/welcome.png",height: 250.0, width: 250.0,),
              SizedBox(height:30.0),
              Text(
                "Mmmm... Delicioso",
                  style: TextStyle(color: Colors.white, fontSize: 30,fontFamily: "Signatra"),
                ),
            ],
          ),
        ),
        ),
        
      );
  }
}
