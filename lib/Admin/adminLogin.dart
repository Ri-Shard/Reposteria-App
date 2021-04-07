import 'package:cloud_firestore/cloud_firestore.dart';
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
