/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/common/colors.dart';
import 'package:flutter/material.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kCategorypinkColor,
          title: Text
          (
            "Reposteria App",
            style: TextStyle(fontSize: 40.0,color: Colors.white,fontFamily: "Signatra"),
          ),
          centerTitle: true,
      ),
      body: AdminSignInScreen(),

    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{
    final TextEditingController _adminIdTextEditingController = TextEditingController();
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
                "images/admin.png",
                height:240.0,
                width:240.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Accede a tu cuenta de Administrador",
                style: TextStyle(color:Colors.pink, fontSize: 20.0, fontWeight: FontWeight.bold ),
              ),
            ),
            Form(
              key:_formKey,
              child: Column(
                children: [

                  CustomTextField(
                    controller: _adminIdTextEditingController,
                    data: Icons.person,
                    hintText:"AdminID",
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
                          SizedBox(
                height:25.0 ,
              ),
              RaisedButton(
              onPressed: () {
                _adminIdTextEditingController.text.isNotEmpty
                 && _passwordTextEditingController.text.isNotEmpty
                 ?loginAdmin() 
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
                height:20.0 ,
              ),
              FlatButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthenticScreen())),
                icon: (Icon(Icons.nature_people,color: Colors.pink)),
                label: Text("No Soy Administrador", style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),),
              ),
                            SizedBox(
                height:50.0 ,
              ),
          ],
        )
      )
    ); 
   }

   loginAdmin()
   {
     Firestore.instance.collection("admins").getDocuments().then((snapshot)
     {
       snapshot.documents.forEach((result){

         if(result.data["id"] != _adminIdTextEditingController.text.trim())
         {
           Scaffold.of(context).showSnackBar(SnackBar(content:Text("Tu identificacion de admin no es correcta")));
         } else if(result.data["password"] != _passwordTextEditingController.text.trim())
         {
          Scaffold.of(context).showSnackBar(SnackBar(content:Text("Tu Contraseña no es correcta")));
         }
         else
         {
          Scaffold.of(context).showSnackBar(SnackBar(content:Text("Bienvenido Administrador, " + result.data["name"])));

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
*/
import 'package:e_shop/Animation/FadeAnimation.dart';
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
                        FadeAnimation(1.2, makeInput(label: "ID Administrador")),
                        FadeAnimation(1.3, makeInput(label: "Contraseña", obscureText: true)),
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
                        onPressed: () {},
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
                      Text("¿No eres Admidistrador?"),
                      Text("Volver", style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18
                      ),),
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
      ),
    );
  }

  Widget makeInput({label, obscureText = false}) {
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