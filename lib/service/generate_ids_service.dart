import 'package:uuid/uuid.dart';

class GenerateIdsService {
  String generateProductId() {
    String formatedProductId;

    String uuid = const Uuid().v4();

    // customize id

    formatedProductId = 'shopify-${uuid.substring(0, 5)}';
    return formatedProductId;
  }

  String generateCategoryId() {
    String formatedCategoryId;
    String uuid = const Uuid().v4();

    //customize id
    formatedCategoryId = "easy-shopping-${uuid.substring(0, 5)}";

    //return
    return formatedCategoryId;
  }
}
