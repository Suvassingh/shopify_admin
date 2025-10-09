import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:shopify_admin/controllers/category_dropdown_controller.dart';
import 'package:shopify_admin/controllers/edit_product_controller.dart';
import 'package:shopify_admin/controllers/is_sale_controller.dart';
import 'package:shopify_admin/models/product_model.dart';
import 'package:shopify_admin/utils/constant.dart';

class EditProductScreen extends StatelessWidget {
  ProductModel productModel;
  EditProductScreen({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProductController>(
      init: EditProductController(productModel: productModel),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Edit Prodcut ${productModel.productName}",
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
                  SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 20,
                      height: Get.height / 4.0,
                      child: GridView.builder(
                        itemCount: controller.images.length,
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
                              CachedNetworkImage(
                                imageUrl: controller.images[index],
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
                                      controller.images[index].toString(),
                                    );
                                    await controller.deleteImagesFromFirStorage(
                                      controller.images[index].toString(),
                                      productModel.productId,
                                    );
                                    EasyLoading.dismiss();
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
                    ),
                  ),
                  // drop down category
                     GetBuilder<CategoryDropDownController>(
                    init: CategoryDropDownController(),
                    builder: (categoriesDropDownController) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<String>(
                                  value: categoriesDropDownController
                                      .selectedCategoryId
                                      ?.value,
                                  items: categoriesDropDownController.categories
                                      .map((category) {
                                        return DropdownMenuItem<String>(
                                          value: category['categoryId'],
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  category['categoryImg']
                                                      .toString(),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              Text(category['categoryName']),
                                            ],
                                          ),
                                        );
                                      })
                                      .toList(),
                                  onChanged: (String? selectedValue) async {
                                    categoriesDropDownController
                                        .setSelectedCategory(selectedValue);
                                    String? categoryName =
                                        await categoriesDropDownController
                                            .getCategoryName(selectedValue);
                                    categoriesDropDownController
                                        .setSelectedCategoryName(categoryName);
                                  },
                                  hint: const Text('Select a category'),
                                  isExpanded: true,
                                  elevation: 10,
                                  underline: const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
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

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
