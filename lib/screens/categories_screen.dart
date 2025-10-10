import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:shopify_admin/controllers/edit_category_controller.dart';
import 'package:shopify_admin/models/category_model.dart';
import 'package:shopify_admin/screens/add_categories_screen.dart';
import 'package:shopify_admin/screens/edit_categories_screen.dart';
import 'package:shopify_admin/utils/constant.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
@override 
void initState(){
  super.initState();
}

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
            color: AppConstant.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppConstant.appMainColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  Get.to(()=>AddCategoriesScreen());
                },
                child: Icon(Icons.add)),
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .orderBy('createdAt', descending: true)
            .snapshots(),
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
            return Container(child: Center(child: Text('No category found!')));
          }

          if (snapshot.data != null) {
            return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];

                CategoriesModel categoriesModel = CategoriesModel(
                  categoryId: data['categoryId'],
                  categoryName: data['categoryName'],
                  categoryImg: data['categoryImg'],
                  createdAt: data['createdAt'],
                  updatedAt: data['updatedAt'],
                );

                return SwipeActionCell(
                  key: ObjectKey(categoriesModel.categoryId),

                  /// this key is necessary
                  trailingActions: <SwipeAction>[
                    SwipeAction(
                      title: "Delete",
                      onTap: (CompletionHandler handler) async {
                        await Get.defaultDialog(
                          title: "Delete Product",
                          content: Text(
                            "Are you sure you want to delete this product?",
                          ),
                          textCancel: "Cancel",
                          textConfirm: "Delete",
                          contentPadding: EdgeInsets.all(10.0),
                          confirmTextColor: Colors.white,
                          onCancel: () {},
                          onConfirm: () async {
                            Get.back(); // Close the dialog
                            EasyLoading.show(status: 'Please wait..');
                            EditCategoryController editCategoryController = Get.put(EditCategoryController(categoriesModel: categoriesModel));
                           await editCategoryController.deleteImagesFromStorage(categoriesModel.categoryImg);
                           await editCategoryController.deleteImageFromFireStore(
                            categoriesModel.categoryImg,
                            categoriesModel.categoryId);
                            await FirebaseFirestore.instance
                                .collection('categories')
                                .doc(categoriesModel.categoryId)
                                .delete();
                            EasyLoading.dismiss();

                          
                          },
                          buttonColor: Colors.red,
                          cancelTextColor: Colors.black,
                        );
                      },
                      color: Colors.red,
                    ),
                  ],
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      onTap:
                          ()
                         
                          {},
                      leading: CircleAvatar(
                        backgroundColor: AppConstant.appScendoryColor,
                        backgroundImage: CachedNetworkImageProvider(
                          categoriesModel.categoryImg.toString(),
                          errorListener: (err) {
                            // Handle the error here
                            print('Error loading image');
                            Icon(Icons.error);
                          },
                        ),
                      ),
                      title: Text(categoriesModel.categoryName),
                      
                      trailing: GestureDetector(
                        onTap: () {
                          Get.to(()=>EditCategoryScreen(categoriesModel:categoriesModel));
                        },
                        child: const Icon(Icons.edit),
                      ),
                    ),
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
