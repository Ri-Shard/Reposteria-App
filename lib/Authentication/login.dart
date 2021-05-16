import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Animation/FadeAnimation.dart';
import 'package:e_shop/Authentication/register.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/common/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>
{
    final TextEditingController _emailTextEditingController = TextEditingController();
    final TextEditingController _passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FadeAnimation(1, Text("Iniciar Sesion", style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),)),
                      SizedBox(height: 20,),
                      FadeAnimation(1.2, Text("Accede a tu cuenta", style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700]
                      ),)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(1.2, makeInput(label: "Email",controller:_emailTextEditingController)),
                        FadeAnimation(1.3, makeInput(label: "Contraseña", obscureText: true,controller:_passwordTextEditingController )),
                      ],
                    ),
                  ),
                  FadeAnimation(1.4, Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          _emailTextEditingController.text.isNotEmpty
                          && _passwordTextEditingController.text.isNotEmpty
                          ?loginUser() 
                          : showDialog(
                            context: context,
                            builder: (c)
                            {
                              return ErrorAlertDialog(message: "Por favor revisa los campos");
                            }
                            );
                        },                         color: AppColors.kCategorypinkColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Text("Iniciar Sesion", style: TextStyle(
                          fontWeight: FontWeight.w600, 
                          fontSize: 18
                        ),),
                      ),
                    ),
                  )),
              FadeAnimation(1.6,FlatButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                      }, 
                      child :Text("¿No tienes cuenta?"+" Registrate", style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16
                         ),),                    
                      ),)
                ],
              ),
            ),
            FadeAnimation(1.2, Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/login.png'),
                  fit: BoxFit.cover
                )
              ),
            ))
          ],
        ),
      ),
    );

  }
  FirebaseAuth _auth = FirebaseAuth.instance;

  void loginUser() async
  {
    showDialog(
      context: context,
      builder:(c)
      {
        return LoadingAlertDialog(message: "Autenticando, Por Favor espere.....",);
      }
    );
    FirebaseUser firebaseUser;
    await _auth.signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
      ).then((authUser){
        firebaseUser = authUser.user;
      }).catchError((error){
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (c)
          {
            return ErrorAlertDialog(message: error.message.toString(),);
          }
      );
      });
      if(firebaseUser != null)
      {
        readData(firebaseUser).then((s){

          Navigator.pop(context);
          Route route = MaterialPageRoute (builder: (c) => StoreHome());
          Navigator.pushReplacement(context, route);
        });
      }
  }
    Future readData(FirebaseUser fUser) async 
  {
    Firestore.instance.collection("users").document(fUser.uid).get().then((dataSnapshot) async {

      await ReposteriaApp.sharedPreferences.setString("uid", dataSnapshot.data[ReposteriaApp.userUID]);
      await ReposteriaApp.sharedPreferences.setString(ReposteriaApp.userEmail, dataSnapshot.data[ReposteriaApp.userEmail]);
      await ReposteriaApp.sharedPreferences.setString(ReposteriaApp.userName, dataSnapshot.data[ReposteriaApp.userName]);

      List<String> cartList = dataSnapshot.data[ReposteriaApp.userCartList].cast<String>();
      await ReposteriaApp.sharedPreferences.setStringList(ReposteriaApp.userCartList,cartList);          
    });

    
  }

  Widget makeInput({label, obscureText = false,controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
          ),
        ),
        SizedBox(height: 30,),
      ],
    );
  }
}