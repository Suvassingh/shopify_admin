import 'package:uuid/uuid.dart';

class GenerateIdsService {
  String generateProductId() {
    String formatedProductId;

    String uuid = const Uuid().v4();

    // customize id

    formatedProductId = 'shopify-${uuid.substring(0, 5)}';
    return formatedProductId;
  }
}
