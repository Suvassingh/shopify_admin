// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:shopify_admin/controllers/add_categotry_image_controller.dart';
// import 'package:shopify_admin/controllers/product_image_controller.dart';
// import 'package:shopify_admin/models/category_model.dart';
// import 'package:shopify_admin/service/generate_ids_service.dart';
// import 'package:shopify_admin/utils/constant.dart';

// class AddCategoriesScreen extends StatelessWidget {
//   const AddCategoriesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     AddCategoryImagesController addCategoryImagesController = Get.put(
//       AddCategoryImagesController(),
//     );
//     TextEditingController categoryNameController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Add Categories",
//           style: TextStyle(
//             color: AppConstant.appTextColor,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: AppConstant.appMainColor,
//         iconTheme: IconThemeData(color: AppConstant.appTextColor),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("Select Images"),
//                     ElevatedButton(
//                       onPressed: () {
//                         addCategoryImagesController.showImagePickerDialog();
//                       },
//                       child: Text("Select Images"),
//                     ),
//                     GetBuilder<AddProductImagesController>(
//                       init: AddProductImagesController(),
//                       builder: (imageController) {
//                         // ignore: prefer_is_empty
//                         return imageController.selectedImages.length > 0
//                             ? Container(
//                                 width: MediaQuery.of(context).size.width - 20,
//                                 height: Get.height / 3.0,
//                                 child: GridView.builder(
//                                   itemCount:
//                                       imageController.selectedImages.length,
//                                   physics: const BouncingScrollPhysics(),
//                                   gridDelegate:
//                                       const SliverGridDelegateWithFixedCrossAxisCount(
//                                         crossAxisCount: 2,
//                                         mainAxisSpacing: 20,
//                                         crossAxisSpacing: 10,
//                                       ),
//                                   itemBuilder: (BuildContext context, int index) {
//                                     return Stack(
//                                       children: [
//                                         Image.file(
//                                           File(
//                                             addCategoryImagesController
//                                                 .selectedImages[index]
//                                                 .path,
//                                           ),
//                                           fit: BoxFit.cover,
//                                           height: Get.height / 4,
//                                           width: Get.width / 2,
//                                         ),
//                                         Positioned(
//                                           right: 10,
//                                           top: 0,
//                                           child: InkWell(
//                                             onTap: () {
//                                               imageController.removeImages(index);
//                                               print(
//                                                 imageController
//                                                     .selectedImages
//                                                     .length,
//                                               );
//                                             },
//                                             child: CircleAvatar(
//                                               backgroundColor:
//                                                   AppConstant.appScendoryColor,
//                                               child: Icon(
//                                                 Icons.close,
//                                                 color: AppConstant.appTextColor,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               )
//                             : SizedBox.shrink();
//                       },
//                     ),
//                     SizedBox(height: 10.0),
//                     Container(
//                       height: 65,
//                       margin: EdgeInsets.symmetric(horizontal: 10.0),
//                       child: TextFormField(
//                         cursorColor: AppConstant.appMainColor,
//                         textInputAction: TextInputAction.next,
//                         // controller: productNameController,
//                         decoration: InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
//                           hintText: "Category Name",
//                           hintStyle: TextStyle(fontSize: 12.0),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                           ),
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         EasyLoading.show();
//                         // Upload images
//                         await addCategoryImagesController.uploadFunction(
//                           addCategoryImagesController.selectedImages,
//                         );
        
//                         String categoryId = await GenerateIdsService()
//                             .generateCategoryId();
//                         CategoriesModel categoriesModel = CategoriesModel(
//                           categoryId: categoryId,
//                           categoryName: categoryNameController.text.trim(),
//                           categoryImg: addCategoryImagesController.arrImageUrl[0]
//                               .toString(),
//                           createdAt: DateTime.now(),
//                           updatedAt: DateTime.now(),
//                         );
        
//                         FirebaseFirestore.instance
//                             .collection('categories')
//                             .doc(categoryId)
//                             .set(categoriesModel.toJson());
//                         EasyLoading.dismiss();
//                       },
//                       child: Text("Save"),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }









import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shopify_admin/controllers/add_categotry_image_controller.dart';

import 'package:shopify_admin/models/category_model.dart';
import 'package:shopify_admin/service/generate_ids_service.dart';
import 'package:shopify_admin/utils/constant.dart';
import 'package:iconsax/iconsax.dart';

class AddCategoriesScreen extends StatelessWidget {
  const AddCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AddCategoryImagesController addCategoryImagesController = Get.put(
      AddCategoryImagesController(),
    );
    TextEditingController categoryNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add New Category",
          style: TextStyle(
            color: AppConstant.appTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppConstant.appMainColor,
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[50],
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Image Selection Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Iconsax.gallery,
                            size: 20,
                            color: Colors.grey[700],
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Category Images",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Add images that represent your category",
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Obx(() {
                        final imageController =
                            Get.find<AddCategoryImagesController>();
                        return imageController.selectedImages.isEmpty
                            ? _buildImagePlaceholder(
                                addCategoryImagesController,
                              )
                            : _buildImageGrid(
                                imageController,
                                addCategoryImagesController,
                              );
                      }),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Category Name Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Iconsax.category,
                            size: 20,
                            color: Colors.grey[700],
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Category Information",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: categoryNameController,
                        cursorColor: AppConstant.appMainColor,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          hintText: "Enter category name",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          labelText: "Category Name",
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppConstant.appMainColor,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Save Button
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (categoryNameController.text.trim().isEmpty) {
                      EasyLoading.showError("Please enter category name");
                      return;
                    }

                    final imageController =
                        Get.find<AddCategoryImagesController>();
                    if (imageController.selectedImages.isEmpty) {
                      EasyLoading.showError("Please select at least one image");
                      return;
                    }

                    EasyLoading.show(status: 'Creating category...');

                    try {
                      // Upload images
                      await addCategoryImagesController.uploadFunction(
                        addCategoryImagesController.selectedImages,
                      );

                      String categoryId = await GenerateIdsService()
                          .generateCategoryId();
                      CategoriesModel categoriesModel = CategoriesModel(
                        categoryId: categoryId,
                        categoryName: categoryNameController.text.trim(),
                        categoryImg: addCategoryImagesController.arrImageUrl[0]
                            .toString(),
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      );

                      await FirebaseFirestore.instance
                          .collection('categories')
                          .doc(categoryId)
                          .set(categoriesModel.toJson());

                      EasyLoading.showSuccess('Category created successfully!');

                      // Clear form
                      categoryNameController.clear();
                      imageController.selectedImages.clear();
                      imageController.update();
                    } catch (e) {
                      EasyLoading.showError('Error creating category: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.appMainColor,
                    foregroundColor: AppConstant.appTextColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Create Category",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(AddCategoryImagesController controller) {
    return GestureDetector(
      onTap: () {
        controller.showImagePickerDialog();
      },
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.gallery_add, size: 32, color: Colors.grey[500]),
            SizedBox(height: 8),
            Text(
              "Tap to select images",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              "Supported: JPG, PNG",
              style: TextStyle(color: Colors.grey[500], fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid(
    AddCategoryImagesController imageController,
    AddCategoryImagesController addCategoryImagesController,
  ) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: imageController.selectedImages.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(
                        addCategoryImagesController.selectedImages[index].path,
                      ),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: GestureDetector(
                    onTap: () {
                      imageController.removeImages(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (index == 0)
                  Positioned(
                    left: 4,
                    bottom: 4,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppConstant.appMainColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Main",
                        style: TextStyle(
                          color: AppConstant.appTextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () {
              addCategoryImagesController.showImagePickerDialog();
            },
            icon: Icon(Iconsax.add, size: 16),
            label: Text("Add More Images"),
            style: TextButton.styleFrom(
              foregroundColor: AppConstant.appMainColor,
            ),
          ),
        ),
      ],
    );
  }
}
