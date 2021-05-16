
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Widgets/style.dart';
import 'package:e_shop/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';


class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
 {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ConstrainedBox(
        constraints:
            BoxConstraints(minWidth: MediaQuery.of(context).size.width - 40),
        child: ElevatedButton(
          onPressed : () =>checkItemInCart(widget.itemModel.shortInfo, context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryText(
                text: 'Poner en el Carrito',
                fontWeight: FontWeight.w600,
                size: 18,
              ),
              Icon(Icons.chevron_right)
            ],
          ),
          style: ElevatedButton.styleFrom(
              primary: AppColors.kCategorypinkColor,
              shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView(
        children: [
          customAppBar(context),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: widget.itemModel.title,
                  size: 45,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(widget.itemModel.thumbnailUrl),
                      ),
                      Container(
                        color:Colors.grey[300],
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                          )
                      )
                    ],
                  ),
                ]
                  )
                  ), 
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text: widget.itemModel.price.toString(),
                      size: 48,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kPrimaryColor,
                      height: 1,
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryText(
                              text: widget.itemModel.shortInfo,
                              color: AppColors.lightGray,
                              size: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            PrimaryText(
                                text: widget.itemModel.longDescription,
                                fontWeight: FontWeight.w600),
                            SizedBox(
                              height: 20,
                            ),

                          ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

    Padding customAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1, color: Colors.grey[400])),
              child: Icon(Icons.chevron_left),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.kCategorypinkColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.star, color: AppColors.kWhiteColor),
          ),
        ],
      ),
    );
  }

}

