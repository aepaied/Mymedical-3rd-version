import 'package:get/get.dart';

class SubTotalController extends GetxController {
  final subTotal = 0.00.obs;

  resetSubTotal() {
    subTotal.value = 0;
  }

  addToSubTotal(double value) {
    subTotal.value += value;
  }
}
