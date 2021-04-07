import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/common/colors.dart';


class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kCategorypinkColor,
          title: Text
          (
            "Reposteria App",
            style: TextStyle(fontSize: 40.0,color: Colors.white,fontFamily: "Signatra"),
          ),
          centerTitle: true,
          bottom: TabBar
          (tabs:[

            Tab(
              icon: Icon(Icons.lock, color: Colors.white,),
              text: "Login",
            ),
            Tab(
              icon: Icon(Icons.perm_contact_calendar, color: Colors.white,),
              text: "Register",
            ),
          ],
          indicatorColor: Colors.white38,
          indicatorWeight: 5.0,
            ),
        ),
        body: Container
        (
          child: TabBarView
          (
            children: [
              Login(),
              Register(),
            ],
            ),
        ),
      ),
      
    );
  }
}
