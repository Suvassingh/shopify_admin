import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopify_admin/utils/constant.dart';

class AddCategoryImagesController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  RxList<XFile> selectedImages = <XFile>[].obs;
  final RxList<String> arrImageUrl = <String>[].obs;

  final FirebaseStorage storageRef = FirebaseStorage.instance;

  Future<void> showImagePickerDialog() async {
    PermissionStatus status;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

    if (androidDeviceInfo.version.sdkInt <= 32) {
      status = await Permission.storage.request();
    } else {
      status = await Permission.mediaLibrary.request();
    }
    //
    if (status == PermissionStatus.granted) {
      Get.defaultDialog(
        title: "Choose Image",
        middleText: "Pick an Image from the camera or gallary",
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              seletcImages("camera");
            },
            child: Text("Camera"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              seletcImages("gallery");
            },
            child: Text("Gallary"),
          ),
        ],
      );
    }
    if (status == PermissionStatus.denied) {
      print("Error please allow the permission for further usage");
      Get.snackbar(
        'Error',
        ' Please allow the permission for further usage',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppConstant.appScendoryColor,
        colorText: AppConstant.appTextColor,
      );
      openAppSettings();
    }
    if (status == PermissionStatus.permanentlyDenied) {
      print("Error please allow the permission for further usage");
      Get.snackbar(
        'Error',
        ' Please allow the permission for further usage',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppConstant.appScendoryColor,
        colorText: AppConstant.appTextColor,
      );
      openAppSettings();
    }
  }

  Future<void> seletcImages(String type) async {
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
      selectedImages.addAll(imgs);
      update();
      print(selectedImages.length);
    }
  }

  void removeImages(int index) {
    selectedImages.removeAt(index);
    update();
  }

  //
  Future<void> uploadFunction(List<XFile> _images) async {
    arrImageUrl.clear();
    for (int i = 0; i < _images.length; i++) {
      dynamic imageUrl = await uplaodFile(_images[i]);
      arrImageUrl.add(imageUrl.toString());
    }
    update();
  }

  //
  Future<String> uplaodFile(XFile _image) async {
    TaskSnapshot reference = await storageRef
        .ref()
        .child("category-image")
        .child(_image.name + DateTime.now().toString())
        .putFile(File(_image.path));

    return await reference.ref.getDownloadURL();
  }

  void clearImages() {
    selectedImages.clear();
    arrImageUrl.clear();
    update();
  }
}
