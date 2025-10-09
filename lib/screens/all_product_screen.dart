import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopify_admin/controllers/category_dropdown_controller.dart';
import 'package:shopify_admin/controllers/is_sale_controller.dart';
import 'package:shopify_admin/models/product_model.dart';
import 'package:shopify_admin/screens/add_product_screen.dart';
import 'package:shopify_admin/screens/edit_product_screen.dart';
import 'package:shopify_admin/screens/product_details_screen.dart';
import 'package:shopify_admin/utils/constant.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All-Products",style: TextStyle(color: AppConstant.appTextColor,fontWeight: FontWeight.bold),),
        backgroundColor: AppConstant.appMainColor,
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: (){
              Get.to(()=>AddProductScreen());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .orderBy('createdAt', descending: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text('Error occurred while fetching category!'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(child: CupertinoActivityIndicator()),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Container(child: Center(child: Text('No Product found!')));
          }

          if (snapshot.data != null) {
            return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];

               ProductModel productModel = ProductModel(
                productId: data['productId'], categoryId: data['categoryId'], productName: data['productName'], categoryName: data['categoryName'], 
                salePrice: data['salePrice'], 
                fullPrice: data['fullPrice'], productImages: data['productImages'], 
                deliveryTime: data['deliveryTime'], 
                isSale: data['isSale'], productDescription: data['productDescription'], 
                createdAt: data['createdAt'], 
                updatedAt: data['updatedAt']);

                return Card(
                  elevation: 5,
                  child: ListTile(
                    onTap: () => Get.to(
                      () =>ProductDetailsScreen(
                        productModel:productModel
                      )
                    ),
                    leading: CircleAvatar(
                      backgroundColor: AppConstant.appScendoryColor,
                      backgroundImage: CachedNetworkImageProvider(
                        productModel.productImages[0],
                        errorListener: (err) {
                          // Handle the error here
                          print('Error loading image');
                          Icon(Icons.error);
                        },
                      ),
                    ),
                    title: Text(productModel.productName),
                    subtitle: Text(productModel.fullPrice),
                    trailing: GestureDetector(
                      onTap: (){
                        final editProductCategory = Get.put(CategoryDropDownController());
                        final isSaleOldValue = Get.put(
                          IsSaleController(),
                        );
                        editProductCategory.setOldValue(productModel.categoryId);
                        isSaleOldValue.setIsSaleOldValue(productModel.isSale);
                        Get.to(()=>EditProductScreen(productModel:productModel));
                      },
                      child: Icon(Icons.edit)),
                  ),
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
