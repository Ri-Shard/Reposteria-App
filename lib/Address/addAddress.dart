import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatelessWidget {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
 // final cCity = TextEditingController();
  //final cDepartment = TextEditingController();
  final cPinCode = TextEditingController();
  final cPhoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed:()
          {
            if(formKey.currentState.validate())
            {
              final model = AddressModel(
                name: cName.text.trim(),
                pincode: cPinCode.text.trim(),
                phoneNumber: cPhoneNumber.text.trim(),
                flatNumber: cFlatHomeNumber.text.trim(),
              ).toJson();

              ReposteriaApp.firestore.collection(ReposteriaApp.collectionUser)
                .document(ReposteriaApp.sharedPreferences.getString(ReposteriaApp.userUID))
                .collection(ReposteriaApp.subCollectionAddress)
                .document(DateTime.now().millisecondsSinceEpoch.toString())
                .setData(model)
                .then((value) {
                  final snack = SnackBar(content: Text("Nueva Direccion añadida satisfactoriamente"));
                  scaffoldKey.currentState.showSnackBar(snack);
                  FocusScope.of(context).requestFocus(FocusNode());
                  formKey.currentState.reset();
                });
            }
          }, 
          label: Text ("Hecho"),
          backgroundColor: Colors.pink,
          icon:Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Añadir una nueva Direccion",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Nombre",
                      controller: cName,
                    ),
                      MyTextField(
                      hint: "Numero de Telefono",
                      controller: cPhoneNumber,
                    ),
                      MyTextField(
                      hint: "Direccion",
                      controller: cFlatHomeNumber,
                    ),
                      MyTextField(
                      hint: "PinCode ",
                      controller: cPinCode,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {

final String hint;
final TextEditingController controller;

MyTextField({Key key, this.hint, this.controller }): super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val) => val.isEmpty ? "Este campo no puede estar Vacio" : null,
      ),
    );
  }
}
