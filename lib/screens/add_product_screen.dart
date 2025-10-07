import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopify_admin/controllers/category_dropdown_controller.dart';
import 'package:shopify_admin/controllers/product_image_controller.dart';
import 'package:shopify_admin/utils/constant.dart';
import 'package:shopify_admin/widgets/dropdown_categories_widget.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  AddProductImagesController addProductImagesController = Get.put(
    AddProductImagesController(),
  );
    CategoryDropDownController categoryDropdownController = Get.put(
    CategoryDropDownController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add-Product",
          style: TextStyle(
            color: AppConstant.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppConstant.appMainColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Select Images"),
                  ElevatedButton(
                    onPressed: () {
                      addProductImagesController.showImagePickerDialog();
                    },
                    child: Text("Select Images"),
                  ),
                ],
              ),
            ),
            GetBuilder<AddProductImagesController>(
              init: AddProductImagesController(),
              builder: (imageController) {
                // ignore: prefer_is_empty
                return imageController.selectedImages.length > 0
                    ? Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: Get.height / 3.0,
                        child: GridView.builder(
                          itemCount: imageController.selectedImages.length,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 10,
                              ),
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              children: [
                                Image.file(
                                  File(
                                    addProductImagesController
                                        .selectedImages[index]
                                        .path,
                                  ),
                                  fit: BoxFit.cover,
                                  height: Get.height / 4,
                                  width: Get.width / 2,
                                ),
                                Positioned(
                                  right: 10,
                                  top: 0,
                                  child: InkWell(
                                    onTap: () {
                                      imageController.removeImages(index);
                                      print(
                                        imageController.selectedImages.length,
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          AppConstant.appScendoryColor,
                                      child: Icon(
                                        Icons.close,
                                        color: AppConstant.appTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : SizedBox.shrink();
              },
            ),
            DropDownCategoriesWiidget()                                  
          ],
        ),
      ),
    );
  }
}
