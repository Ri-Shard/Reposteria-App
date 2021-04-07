import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}



class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
{
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file ==null ? displayAdminHomeScreen() : displayAdminUploadFormScreen();
  }


  displayAdminHomeScreen()
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink ,
        leading: IconButton(
          icon: Icon(Icons.border_color, color: Colors.white,),
          onPressed: ()
          {
            
          Route route = MaterialPageRoute (builder: (c) => AdminShiftOrders());
          Navigator.pushReplacement(context, route);
          },
          ),
          actions: [
            FlatButton(
              child: Text("Cerrar Sesion", style:TextStyle(color: Colors.white,fontSize: 16.0, fontWeight:FontWeight.bold )),
              onPressed: ()
              {  
              Route route = MaterialPageRoute (builder: (c) => SplashScreen());
              Navigator.pushReplacement(context, route);
              },
              ),
          ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }
  getAdminHomeScreenBody()
  {
    return Container
    (
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shop_two,color: Colors.pink,size: 200.0,),
            Padding(
              padding: EdgeInsets.only(top:20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                child: Text("Añadir nuevos productos",style:TextStyle(fontSize: 20.0,color:Colors.white) ),
                color: Colors.green,
                onPressed: ()=>takeImage(context)	,
              ),
              ), 
          ],
        ),
      ),
    );
  }
  takeImage(mContext)
  {
    return showDialog(
      context: mContext,
      builder: (con)
      {
        return SimpleDialog(
          title: Text("Imagen del Producto",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold ),),
          children: [
            SimpleDialogOption(
            child: Text("Seleccionar Imagen", style: TextStyle(color: Colors.green),),
            onPressed: pickPhotoFromGallery,
            ),
            SimpleDialogOption(
            child: Text("Cancel", style: TextStyle(color: Colors.green),),
            onPressed: ()
            {
              Navigator.pop(context);
            },
            ),
          ],
        );
      }
    );
  }

  pickPhotoFromGallery() async 
  {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(()
    {
       file = imageFile; 
    });
  }

  displayAdminUploadFormScreen()
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white),onPressed: clearFormInfo,),
        title: Text("Nuevo Producto",style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold)),
        actions: [
          FlatButton(
            onPressed: uploading ? null :  () => uploadImageAndSaveItemInfo(),
            child: Text("Añadir",style: TextStyle(color: Colors.white, fontSize: 16.0,fontWeight: FontWeight.bold  ),),
            )
        ],
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() :Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width*0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: FileImage(file),fit: BoxFit.cover)),
                ),
                ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top:12.0)),

          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.pink),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _shortInfoTextEditingController,
                decoration: InputDecoration(
                  hintText: "Informacion corta",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                )
                ,)
            ),
          ),
          Divider(color: Colors.pink,),
                    ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.pink),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _titleTextEditingController,
                decoration: InputDecoration(
                  hintText: "Nombre ",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                )
                ,)
            ),
          ),
          Divider(color: Colors.pink,),
                    ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.pink),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: " Descripcion ",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                )
                ,)
            ),
          ),
          Divider(color: Colors.pink,),
                              ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.pink),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _priceTextEditingController,
                decoration: InputDecoration(
                  hintText: " Precio ",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                )
                ,)
            ),
          ),
          Divider(color: Colors.pink,),
        ],

      ),
    );
  }
  clearFormInfo()
  {
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
    });
  }
  uploadImageAndSaveItemInfo() async
  {
    setState(() {
      uploading = true;
    });  
    String imageDownloadUrl = await uploadItemImage(file);
    saveItemInfo(imageDownloadUrl);
  }
  Future<String> uploadItemImage(mFileImage) async
  {
    final StorageReference storageReference = FirebaseStorage.instance.ref().child("items");
    StorageUploadTask uploadTask = storageReference.child("product_$productId.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(String downloadUrl)
  {
    final itemsRef = Firestore.instance.collection("items");
    itemsRef.document(productId).setData({
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "price": int.parse(_priceTextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "Disponible",
      "thumbnailUrl": downloadUrl,
      "title": _titleTextEditingController.text.trim(),
    });

    setState(() {
      
      file=null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _priceTextEditingController.clear();

    });
  }
}
