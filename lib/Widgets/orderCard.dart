import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Orders/OrderDetailsPage.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';

int counter = 0;
class OrderCard extends StatelessWidget {

  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderId;

  OrderCard({Key key, this.itemCount,this.data,this.orderId}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: ()
      {
        Route route;
        if(counter == 0)
        {
          counter = counter +1;
          route = MaterialPageRoute(builder: (c) => OrderDetails(orderId: orderId));
        }
        Navigator.push(context, route);
      },
      child: Container(
        color: Colors.pink,
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: itemCount*190.0,
        child: ListView.builder(
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (c,index)
          {
            ItemModel model = ItemModel.fromJson(data[index].data);
            return sourceOrderInfo(model,context);
          },
        ),
      ),
    );
  }
}



Widget sourceOrderInfo(ItemModel model, BuildContext context,
    {Color background})
{
  width =  MediaQuery.of(context).size.width;

  return  Container(
        color: Colors.grey[100],
        height: 170.0,
        width: width,
        child: Row(
          children: [
            Image.network(model.thumbnailUrl,width:180.0),
            SizedBox(width:10.0),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:15.0),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: Text(model.title,style:TextStyle(color: Colors.black,fontSize: 14.0))),                      
                    ],
                  ) ,
                  ),
                  SizedBox(height: 5.0,),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: Text(model.shortInfo, style:TextStyle(color: Colors.black54,fontSize: 12.0))),                      
                    ],
                  ) ,
                  ),
                    SizedBox(height: 20.0,),
                    Row(
                      children: [
                        SizedBox(width:10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Padding(
                              padding: EdgeInsets.only(top:5.0),
                              child: Row(
                                children: [
                                  Text(
                                    r"Precio Total:",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    r"$",
                                    style: TextStyle(color:Colors.red, fontSize: 16.0),
                                  ),
                                  
                                  Text(
                                    (model.price).toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Flexible(
                      child: Container( ),
                    ),
                    //to implement the cart item add/remove feature              
                    Divider(
                      height: 5.0,
                      color: Colors.pink
                    ),
              ],
            ),
            ),
          ],
        ),
      );
}
