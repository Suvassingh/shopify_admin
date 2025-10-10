
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopify_admin/models/category_model.dart';

class EditCategoryController extends GetxController {
  CategoriesModel categoriesModel;
  EditCategoryController({required this.categoriesModel});

  Rx<String> categoryImages = ''.obs;
  RxList<XFile> selectedImages = <XFile>[].obs;
  final RxList<String> arrImageUrl = <String>[].obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    getRealTimeCategoryImages();
  }

  void getRealTimeCategoryImages() {
      if (categoriesModel.categoryId == null || categoriesModel.categoryId!.isEmpty) {
      print("Error: categoriesModel.categoryId is null or empty");
      return;
    }
    FirebaseFirestore.instance
        .collection('categories')
        .doc(categoriesModel.categoryId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data() as Map<String, dynamic>?;
            if (data != null && data['categoryImg'] != null) {
              categoryImages.value = data['categoryImg'].toString();
              update();
            }
          }
        });
  }

  // Image selection methods
  Future<void> selectImages(String type) async {
    List<XFile> imgs = [];
    if (type == 'gallery') {
      try {
        imgs = await _picker.pickMultiImage(imageQuality: 80);
        update();
      } catch (e) {
        print('Error $e');
      }
    } else {
      final img = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (img != null) {
        imgs.add(img);
        update();
      }
    }

    if (imgs.isNotEmpty) {
      selectedImages.assignAll(imgs); // Replace with new images
      update();
            print(selectedImages.length);

    }
  }

  // Upload new images
  Future<void> uploadNewImages() async {
    if (selectedImages.isEmpty) return;

    arrImageUrl.clear();
    for (int i = 0; i < selectedImages.length; i++) {
      String imageUrl = await uploadFile(selectedImages[i]);
      arrImageUrl.add(imageUrl);
    }

    // Update Firestore with new images
    if (arrImageUrl.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoriesModel.categoryId)
          .update({
            'categoryImg':
                arrImageUrl.first, // Assuming single image for category
          });
    }
    update();
  }

  Future<String> uploadFile(XFile _image) async {
    TaskSnapshot reference = await FirebaseStorage.instance
        .ref()
        .child("category-image")
        .child(_image.name + DateTime.now().toString())
        .putFile(File(_image.path));

    return await reference.ref.getDownloadURL();
  }

  // Delete images
  Future deleteImagesFromStorage(String imageUrl) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    try {
      Reference reference = storage.refFromURL(imageUrl);
      await reference.delete();
    } catch (e) {
      print("error $e");
    }
  }

  Future<void> deleteImagesFromFirStorage(
    String imageUrl,
    String categoryId,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .update({'categoryImg': FieldValue.delete()});
      categoryImages.value = ''; // Clear the local image
      update();
    } catch (e) {
      print("error $e");
    }
  }

  void clearSelectedImages() {
    selectedImages.clear();
    update();
  }
}







// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/get.dart';
// import 'package:shopify_admin/models/category_model.dart';

// class EditCategoryController extends GetxController {
//   CategoriesModel categoriesModel;
//   EditCategoryController({required this.categoriesModel});
//   Rx<String> categoryImages = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     getRealTimeCategoryImages();
//   }

//   void getRealTimeCategoryImages() {
//       if (categoriesModel.categoryId == null || categoriesModel.categoryId!.isEmpty) {
//       print("Error: categoriesModel.categoryId is null or empty");
//       return;
//     }
//     FirebaseFirestore.instance
//         .collection('categories')
//         .doc(categoriesModel.categoryId)
//         .snapshots()
//         .listen((DocumentSnapshot snapshot) {
//           if (snapshot.exists) {
//             final data = snapshot.data() as Map<String, dynamic>?;
//             if (data != null && data['categoryImg'] != null) {
//               categoryImages.value = data['categoryImg'].toString();
//               update();
//             }
//           }
//         });
//   }

//   // delete images
//   Future deleteImagesFromStorage(String imageUrl) async {
//     final FirebaseStorage storage = FirebaseStorage.instance;
//     try {
//       Reference reference = storage.refFromURL(imageUrl);
//       await reference.delete();
//     } catch (e) {
//       print("error $e");
//     }
//   }

//   Future<void> deleteImagesFromFirStorage(
//     String imageUrl,
//     String productId,
//   ) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('categories')
//           .doc(productId)
//           .update({
//             'categoryImg': FieldValue.arrayRemove([imageUrl]),
//           });
//       update();
//     } catch (e) {
//       print("error $e");
//     }
//   }
// }
