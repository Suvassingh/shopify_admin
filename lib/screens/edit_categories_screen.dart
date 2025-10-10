// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:shopify_admin/controllers/add_categotry_image_controller.dart';
// import 'package:shopify_admin/controllers/edit_category_controller.dart';
// import 'package:shopify_admin/controllers/product_image_controller.dart';
// import 'package:shopify_admin/models/category_model.dart';
// import 'package:shopify_admin/utils/constant.dart';

// class 
// // ignore: must_be_immutable
// EditCategoriesScreen extends StatefulWidget {
//   CategoriesModel categoriesModel; 
//   EditCategoriesScreen({super.key, required  this.categoriesModel});

//   @override
//   State<EditCategoriesScreen> createState() => _EditCategoriesScreenState();
// }

// class _EditCategoriesScreenState extends State<EditCategoriesScreen> {
//     AddCategoryImagesController addCategoryImagesController = Get.put(
//     AddCategoryImagesController(),
//   );
//   TextEditingController categoryNameController = TextEditingController();
//   void initState(){
//     super.initState();
//     categoryNameController.text = widget.categoriesModel.categoryName;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppConstant.appMainColor,
//         title: Text(widget.categoriesModel.categoryName),
//       ),
//       body: Container(
//         child: Column(
//           children: [
//             GetBuilder(
//               init: EditCategoryController(
//                 categoriesModel: widget.categoriesModel,
//               ),
//               builder: (editCategory) {
//                 return editCategory.categoryImages.value != ''
//                     ? Stack(
//                         children: [
//                           CachedNetworkImage(
//                             imageUrl: editCategory.categoryImages.value.toString(),
//                             fit: BoxFit.contain,
//                             height: Get.height / 5.5,
//                             width: Get.width / 2,
//                             placeholder: (context, url) => const Center(
//                               child: CupertinoActivityIndicator(),
//                             ),
//                             errorWidget: (context, url, error) =>
//                                 const Icon(Icons.error),
//                           ),
//                           Positioned(
//                             right: 10,
//                             top: 0,
//                             child: InkWell(
//                               onTap: () async {
//                                 EasyLoading.show();
//                                 await editCategory.deleteImagesFromStorage(
//                                   editCategory.categoryImages.value.toString(),
//                                 );
//                                 await editCategory.deleteImagesFromFirStorage(
//                                   editCategory.categoryImages.value.toString(),
//                                   widget.categoriesModel.categoryId,
//                                 );
//                                 EasyLoading.dismiss();
//                               },
//                               child: const CircleAvatar(
//                                 backgroundColor: AppConstant.appScendoryColor,
//                                 child: Icon(
//                                   Icons.close,
//                                   color: AppConstant.appTextColor,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     : const SizedBox.shrink();
//               },
//             ),

//             //
//             const SizedBox(height: 10.0),
//             Container(
//               height: 65,
//               margin: const EdgeInsets.symmetric(horizontal: 10.0),
//               child: TextFormField(
//                 cursorColor: AppConstant.appMainColor,
//                 textInputAction: TextInputAction.next,
//                 controller: categoryNameController,
//                 decoration: const InputDecoration(
//                   contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
//                   hintText: "Product Name",
//                   hintStyle: TextStyle(fontSize: 12.0),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                   ),
//                 ),
//               ),
//             ),

//             ElevatedButton(
//               onPressed: () async {
//                 EasyLoading.show();
//                 CategoriesModel categoriesModel = CategoriesModel(
//                   categoryId: widget.categoriesModel.categoryId,
//                   categoryName: categoryNameController.text.trim(),
//                   categoryImg: widget.categoriesModel.categoryImg,
//                   createdAt: widget.categoriesModel.createdAt,
//                   updatedAt: DateTime.now(),
//                 );

//                 await FirebaseFirestore.instance
//                     .collection('categories')
//                     .doc(categoriesModel.categoryId)
//                     .update(categoriesModel.toJson());

//                 EasyLoading.dismiss();
//               },
//               child: const Text("Update"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopify_admin/controllers/edit_category_controller.dart';
import 'package:shopify_admin/models/category_model.dart';
import 'package:shopify_admin/utils/constant.dart';

class EditCategoriesScreen extends StatefulWidget {
  CategoriesModel categoriesModel;
  EditCategoriesScreen({super.key, required this.categoriesModel});

  @override
  State<EditCategoriesScreen> createState() => _EditCategoriesScreenState();
}

class _EditCategoriesScreenState extends State<EditCategoriesScreen> {
// EditCategoryController editCategoryController = Get.put(EditCategoryController(categoriesModel:categoriesModel ))
  TextEditingController categoryNameController = TextEditingController();
  EditCategoryController editCategoryController = Get.put(
    EditCategoryController(
      categoriesModel: CategoriesModel(
        categoryId: '',
        categoryName: '',
        categoryImg: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ),
  );

  void initState() {
    super.initState();
    categoryNameController.text = widget.categoriesModel.categoryName;
    editCategoryController = EditCategoryController(
      categoriesModel: widget.categoriesModel,
    );
  }

  Future<void> _showImagePickerDialog() async {
    Get.defaultDialog(
      title: "Choose Image",
      middleText: "Pick an Image from the camera or gallery",
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          ("camera");
          },
          child: Text("Camera"),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            editCategoryController.selectImages("gallery");
          },
          child: Text("Gallery"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Category ${widget.categoriesModel.categoryName}",
          style: TextStyle(
            color: AppConstant.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppConstant.appMainColor,
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              GetBuilder<EditCategoryController>(
                init: editCategoryController,
                builder: (controller) {
                  // Show selected new images first
                  if (controller.selectedImages.isNotEmpty) {
                    return Stack(
                      children: [
                        Image.file(
                          File(controller.selectedImages.first.path),
                          fit: BoxFit.contain,
                          height: Get.height / 5.5,
                          width: Get.width / 2,
                        ),
                        Positioned(
                          right: 10,
                          top: 0,
                          child: InkWell(
                            onTap: () {
                              controller.clearSelectedImages();
                            },
                            child: CircleAvatar(
                              backgroundColor: AppConstant.appScendoryColor,
                              child: Icon(
                                Icons.close,
                                color: AppConstant.appTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  // Show existing image from Firestore
                  else if (controller.categoryImages.value.isNotEmpty) {
                    return Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: controller.categoryImages.value,
                          fit: BoxFit.contain,
                          height: Get.height / 5.5,
                          width: Get.width / 2,
                          placeholder: (context, url) =>
                              Center(child: CupertinoActivityIndicator()),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        Positioned(
                          right: 10,
                          top: 0,
                          child: InkWell(
                            onTap: () async {
                              EasyLoading.show();
                              await controller.deleteImagesFromStorage(
                                controller.categoryImages.value,
                              );
                              await controller.deleteImagesFromFirStorage(
                                controller.categoryImages.value,
                                widget.categoriesModel.categoryId,
                              );
                              EasyLoading.dismiss();
                            },
                            child: CircleAvatar(
                              backgroundColor: AppConstant.appScendoryColor,
                              child: Icon(
                                Icons.close,
                                color: AppConstant.appTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  // Show image selection option
                  else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Select Images"),
                          ElevatedButton(
                            onPressed: () {
                              _showImagePickerDialog();
                            },
                            child: Text("Select Images"),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: categoryNameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    hintText: "Category Name",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GetBuilder<EditCategoryController>(
                builder: (controller) {
                  return ElevatedButton(
                    onPressed: () async {
                      EasyLoading.show();

                      // If there are new images selected, upload them first
                      if (controller.selectedImages.isNotEmpty) {
                        await controller.uploadNewImages();
                      }

                      // Update category details
                      CategoriesModel categoriesModel = CategoriesModel(
                        categoryId: widget.categoriesModel.categoryId,
                        categoryName: categoryNameController.text.trim(),
                        categoryImg: controller
                            .categoryImages
                            .value, // This will be updated after upload
                        createdAt: widget.categoriesModel.createdAt,
                        updatedAt: DateTime.now(),
                      );

                      await FirebaseFirestore.instance
                          .collection('categories')
                          .doc(categoriesModel.categoryId)
                          .update(categoriesModel.toJson());

                      EasyLoading.dismiss();
                      Get.back(); // Go back after update
                    },
                    child: const Text("Update Category"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
