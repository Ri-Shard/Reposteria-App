import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>
{
    final TextEditingController _emailTextEditingController = TextEditingController();
    final TextEditingController _passwordTextEditingController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();




  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child:Container(
        child:Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Image.asset(
                "images/login.png",
                height:240.0,
                width:240.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Accede a tu cuenta",
                style: TextStyle(color:Colors.white),
              ),
            ),
            Form(
              key:_formKey,
              child: Column(
                children: [

                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText:"Email",
                    isObsecure:false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.lock,
                    hintText:"Contraseña",
                    isObsecure:true,
                  ),                                  
                ],
            ),
            ),
              RaisedButton(
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
              }, 
              color:Colors.pink,
              child: Text("Ingresar", style: TextStyle(color: Colors.white),),
            ),
             SizedBox(
              height: 50.0,
            ),
            Container(
              height: 4.0 ,
              width: _screenWidth*0.8,
              color:Colors.pink,
              ),
              SizedBox(
                height:10.0 ,
              ),
              FlatButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminSignInPage())),
                icon: (Icon(Icons.nature_people,color: Colors.pink)),
                label: Text("Soy Administrador", style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),),
              ),
          ],
        )
      )
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
      ).then((authUser)
      {
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
      await ReposteriaApp.sharedPreferences.setString(ReposteriaApp.userAvatarUrl,dataSnapshot.data[ReposteriaApp.userAvatarUrl] );

      List<String> cartList = dataSnapshot.data[ReposteriaApp.userCartList].cast<String>();
      await ReposteriaApp.sharedPreferences.setStringList(ReposteriaApp.userCartList,cartList);          
    });

    
  }
}
