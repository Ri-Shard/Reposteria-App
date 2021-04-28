import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Animation/FadeAnimation.dart';
import 'package:e_shop/Authentication/login.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/common/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: RegisterBody(),
    );
  }
}

  class RegisterBody extends StatefulWidget {
  @override
  _RegisterBody createState() => _RegisterBody();
  }

  class _RegisterBody extends State<RegisterBody> {
    final TextEditingController _nameTextEditingController = TextEditingController();
    final TextEditingController _emailTextEditingController = TextEditingController();
    final TextEditingController _passwordTextEditingController = TextEditingController();
    final TextEditingController _cPasswordTextEditingController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    @override
   Widget build(BuildContext context) {
            return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(1, Text("Registrarse", style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),)),
                  SizedBox(height: 20,),
                  FadeAnimation(1.2, Text("Create una cuenta, es gratis", style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700]
                  ),)),
                ],
              ),
              Column(
                children: <Widget>[
                  FadeAnimation(1.2, makeInput(label: "Nombre",controller: _nameTextEditingController)),
                  FadeAnimation(1.2, makeInput(label: "Email",controller: _emailTextEditingController)),
                  FadeAnimation(1.3, makeInput(label: "Contraseña", obscureText: true,controller:_passwordTextEditingController)),
                  FadeAnimation(1.4, makeInput(label: "Confirmar Contraseña", obscureText: true,controller: _cPasswordTextEditingController)),
                ],
              ),
              FadeAnimation(1.5, Container(
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
                   onPressed: () {upload();}, 
                  color: kCategorypinkColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Text("Registrarse", style: TextStyle(
                    fontWeight: FontWeight.w600, 
                    fontSize: 18
                  ),),
                ),
              )),
              
              FadeAnimation(1.6,FlatButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                      },                       
                      child :Text("¿Ya tienes cuenta?"+" Inicia Sesion", style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16
                         ),),                    
                      ),)
            ],
          ),
        ),
      );
   }

     upload(){
     _passwordTextEditingController.text == _cPasswordTextEditingController.text
     ? _emailTextEditingController.text.isNotEmpty && 
     _passwordTextEditingController.text.isNotEmpty &&
      _cPasswordTextEditingController.text.isNotEmpty && 
      _nameTextEditingController.text.isNotEmpty

      ? uploadToStorage()
      :showDialog(
        context: context,
        builder: (c)
        {
          return ErrorAlertDialog(message: "Por favor llene completamente los datos");
        }
       )
      :showDialog(
        context: context,
        builder: (c)
        {
          return ErrorAlertDialog(message: "Las contraseñas no coinciden");
        }
       );

   }

   uploadToStorage(){
    showDialog
    (
      context: context,
      builder: (c)
      {
        return LoadingAlertDialog(message: "Registrando, Por Favor espere.....");
      }
    );
    _registerUser();
   }
   FirebaseAuth _auth = FirebaseAuth.instance;
void _registerUser() async
{
  FirebaseUser firebaseUser;
  await _auth.createUserWithEmailAndPassword
  (
    email: _emailTextEditingController.text.trim(),
   password: _passwordTextEditingController.text.trim(),
   ).then((auth){
     firebaseUser = auth.user;
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
     saveUSerInfoToFireStore(firebaseUser).then((value){
       Navigator.pop(context);
       Route route = MaterialPageRoute (builder: (c) => StoreHome());
       Navigator.pushReplacement(context, route);
     });
   }
}
  Future saveUSerInfoToFireStore(FirebaseUser fUser) async
  {
    Firestore.instance.collection("users").document(fUser.uid).setData({
      "uid":fUser.uid,
      "email":fUser.email,
      "name":_nameTextEditingController.text.trim(),
      ReposteriaApp.userCartList : ["garbageValue"],
    });

    await ReposteriaApp.sharedPreferences.setString("uid", fUser.uid);
    await ReposteriaApp.sharedPreferences.setString(ReposteriaApp.userEmail, fUser.email);
    await ReposteriaApp.sharedPreferences.setString(ReposteriaApp.userName, _nameTextEditingController.text.trim(),);
    await ReposteriaApp.sharedPreferences.setStringList(ReposteriaApp.userCartList, ["garbageValue"]);
    
  }
    }


  Widget makeInput({label, obscureText = false, controller}) {
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


  
