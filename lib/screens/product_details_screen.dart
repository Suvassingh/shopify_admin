import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopify_admin/models/product_model.dart';
import 'package:shopify_admin/utils/constant.dart';

// ignore: must_be_immutable
class ProductDetailsScreen extends StatefulWidget {
   ProductModel productModel;
   ProductDetailsScreen({super.key, required this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productModel.productName),
        centerTitle: true,
        backgroundColor: AppConstant.appMainColor,

      ),
      body: Container(
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Product Name"),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                           widget.productModel.productName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Product Price"),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                           widget.productModel.salePrice != ''
                                ?widget.productModel.salePrice
                                :widget.productModel.fullPrice,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Delivery Time"),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                           widget.productModel.deliveryTime,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Is Sale?"),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            widget.productModel.isSale ? "True" : "false",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  }