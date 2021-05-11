import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Animation/FadeAnimation.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/common/colors.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
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
      body: AdminSignInScreen(),
      
    );
  }
  }
  class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
  }
  class _AdminSignInScreenState extends State<AdminSignInScreen> {
    final TextEditingController _adminIdTextEditingController = TextEditingController();
    final TextEditingController _passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return       Container(
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
                      FadeAnimation(1.2, Text("Accede a tu cuenta de Administrador", style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700]
                      ),)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(1.2, makeInput(label: "ID Administrador",controller:_adminIdTextEditingController)),
                        FadeAnimation(1.3, makeInput(label: "Contraseña", obscureText: true, controller: _passwordTextEditingController)),
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
                          onPressed: ()  {
                            _adminIdTextEditingController.text.isNotEmpty
                            && _passwordTextEditingController.text.isNotEmpty
                            ?loginAdmin() 
                            :showDialog(
                              context: context,
                              builder: (c)
                              {
                                return ErrorAlertDialog(message: "Por favor revisa los campos");
                              }
                              );                         
                          },
                        color: kCategorypinkColor,
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
                  FadeAnimation(1.5, Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: (){Navigator.pop(context);},                       
                      child :Text("¿No eres Administrador?"+" Volver", style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16
                      ),),                    
                      ),
                    ],
                  ))
                ],
              ),
            ),
            FadeAnimation(1.2, Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/Checklist.png'),
                  fit: BoxFit.cover
                )
              ),
            ))
          ],
        ),
      );
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
          autofocus: false,
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
          controller: controller,
        ),
        SizedBox(height: 30,),
      ],
    );
  }

   loginAdmin()
   {
     Firestore.instance.collection("admins").getDocuments().then((snapshot)
     {
       snapshot.documents.forEach((result){

         if(result.data["id"] != _adminIdTextEditingController.text.trim())
         {
            showDialog(
              context: context,
              builder: (c)
              {
                return ErrorAlertDialog(message: "Id de Administrador Erronea");
              }
              );
           
         } else if(result.data["password"] != _passwordTextEditingController.text.trim())
         {
            showDialog(
              context: context,
              builder: (c)
              {
                return ErrorAlertDialog(message: "Contraseña Incorrecta");
              }
              );
         }
         else
         {
          setState(()
          {
            _adminIdTextEditingController.text = "";
            _passwordTextEditingController.text = "";
          });   

          Route route = MaterialPageRoute (builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
         }
       });
     });
   }
}
        

