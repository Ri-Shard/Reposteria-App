import 'package:e_shop/common/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorAlertDialog extends StatelessWidget
{
  final String message;
  const ErrorAlertDialog({Key key, this.message}) : super(key: key);


  @override
  Widget build(BuildContext context)
  {
    return AlertDialog(
      key: key,
      content: Text(message,textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold)),
      actions: <Widget>[
        MaterialButton(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40), 
          ),          
          onPressed: ()
        {
          Navigator.pop(context);
        },
          color: kCategorypinkColor,
          child: Center(
            child: Text("OK"),
          ),
        )
      ],
    );
  }
}
