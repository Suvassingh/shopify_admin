import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shopify_admin/controllers/category_dropdown_controller.dart';
import 'package:shopify_admin/controllers/is_sale_controller.dart';
import 'package:shopify_admin/controllers/product_image_controller.dart';
import 'package:shopify_admin/models/product_model.dart';
import 'package:shopify_admin/utils/constant.dart';
import 'package:shopify_admin/widgets/dropdown_categories_widget.dart';
import 'package:shopify_admin/service/generate_ids_service.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  AddProductImagesController addProductImagesController = Get.put(
    AddProductImagesController(),
  );
  CategoryDropDownController categoryDropdownController = Get.put(
    CategoryDropDownController(),
  );
  IsSaleController isSaleController = Get.put(IsSaleController());
  TextEditingController productNameController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController fullPriceController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
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
              DropDownCategoriesWiidget(),
              GetBuilder<IsSaleController>(
                init: IsSaleController(),
                builder: (isSaleController) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("isSale"),
                          Switch(
                            value: isSaleController.isSale.value,
                            activeColor: AppConstant.appMainColor,
                            onChanged: (value) {
                              isSaleController.toggleIsSale(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // form
              SizedBox(height: 10.0),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: productNameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    hintText: "Product Name",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),

              Obx(() {
                return isSaleController.isSale.value
                    ? Container(
                        height: 65,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          cursorColor: AppConstant.appMainColor,
                          textInputAction: TextInputAction.next,
                          controller: salePriceController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            hintText: "Sale Price",
                            hintStyle: TextStyle(fontSize: 12.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink();
              }),

              SizedBox(height: 10.0),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: fullPriceController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    hintText: "Full Price",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.0),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: deliveryTimeController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    hintText: "Delivery Time",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.0),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: productDescriptionController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    hintText: "Product Desc",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),

              // ElevatedButton(onPressed: ()async{
              // //   String productId = await GenerateIdsService().generateProductId();
              // //   print(productId);
              // // }, child: Text("Upload"))
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.appMainColor,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                onPressed: () async {
                  if (categoryDropdownController.selectedCategoryId == null ||
                      productNameController.text.trim().isEmpty ||
                      fullPriceController.text.trim().isEmpty ||
                      deliveryTimeController.text.trim().isEmpty ||
                      productDescriptionController.text.trim().isEmpty ||
                      addProductImagesController.selectedImages.isEmpty ||
                      (isSaleController.isSale.value &&
                          salePriceController.text.trim().isEmpty)) {
                    Get.snackbar(
                      "Error",
                      "Please fill all the required fields and select images",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  try {
                    EasyLoading.show(status: "Uploading...");

                    // Upload images
                    await addProductImagesController.uploadFunction(
                      addProductImagesController.selectedImages,
                    );

                    // Generate Product ID
                    String productId = await GenerateIdsService()
                        .generateProductId();

                    // Create product model
                    ProductModel productModel = ProductModel(
                      productId: productId,
                      categoryId: categoryDropdownController.selectedCategoryId
                          .toString(),
                      categoryName: categoryDropdownController
                          .selectedCategoryName
                          .toString(),
                      productName: productNameController.text.trim(),
                      salePrice: isSaleController.isSale.value
                          ? salePriceController.text.trim()
                          : "",
                      fullPrice: fullPriceController.text.trim(),
                      productImages: addProductImagesController.arrImageUrl,
                      deliveryTime: deliveryTimeController.text.trim(),
                      isSale: isSaleController.isSale.value,
                      productDescription: productDescriptionController.text
                          .trim(),
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );

                    // Upload to Firestore
                    await FirebaseFirestore.instance
                        .collection('products')
                        .doc(productId)
                        .set(productModel.toMap());

                    EasyLoading.dismiss();

                    // Success message
                    Get.snackbar(
                      "Success",
                      "Product uploaded successfully!",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );

                    // Clear fields
                    productNameController.clear();
                    salePriceController.clear();
                    fullPriceController.clear();
                    deliveryTimeController.clear();
                    productDescriptionController.clear();
                    addProductImagesController.clearImages();
                    isSaleController.isSale.value = false;
                  } catch (e) {
                    EasyLoading.dismiss();
                    print("Upload Error: $e");
                    Get.snackbar(
                      "Error",
                      "Something went wrong: $e",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: Text(
                  "Upload Product",
                  style: TextStyle(
                    color: AppConstant.appTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
