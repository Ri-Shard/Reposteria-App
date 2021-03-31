import 'dart:io';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

import '../Widgets/customTextField.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register>
{
  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _cPasswordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;


  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView
    (
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              onTap:() => print("Selected"),
              child: CircleAvatar(
                radius: _screenWidth*0.15,
                backgroundColor: Colors.white,
                backgroundImage: _imageFile == null ? null :FileImage(_imageFile),
                child: _imageFile ==null 
                ?Icon(Icons.add_photo_alternate,size: _screenWidth*0.15, color: Colors.grey)
                : null,
              ),
            ),
            SizedBox(height: 8.0,),
            Form(
              key:_formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.person,
                    hintText:"Nombre",
                    isObsecure:false,
                  ),
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
                  CustomTextField(
                    controller: _cPasswordTextEditingController,
                    data: Icons.lock,
                    hintText:"Comfirmar Contraseña",
                    isObsecure:true,
                  ),                                  
                ],
            ),
            ),
            RaisedButton(
              onPressed: ()=>("clicked"),
              color:Colors.pink,
              child: Text("Iniciar Sesion", style: TextStyle(color: Colors.white),),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 4.0 ,
              width: _screenWidth*0.8,
              color:Colors.pink,
              ),
              SizedBox(
                height:15.0 ,
              )
          ],
        ),
      ),
    );
  }
}

