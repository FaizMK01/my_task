import 'package:evencir_task/modules/favorites/favorites_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  final dynamic product;
  
  var currentImageIndex = 0.obs;
  var quantity = 1.obs;
  
  late PageController pageController;
  late FavoritesController favoritesController;

  ProductDetailController(this.product);

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    
    // Initialize or get existing favorites controller
    try {
      favoritesController = FavoritesController.instance;
    } catch (e) {
      favoritesController = Get.put(FavoritesController());
    }
    
    // Initialize quantity with minimum order quantity
    quantity.value = product.minimumOrderQuantity ?? 1;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // Reactive getter for favorite status
  bool get isFavorite => favoritesController.isFavorite(product);

  void updateCurrentImageIndex(int index) {
    currentImageIndex.value = index;
  }

  void increaseQuantity() {
    if (quantity.value < (product.stock ?? 0)) {
      quantity.value++;
    } else {
      Get.snackbar(
        "Stock Limit",
        "Only ${product.stock ?? 0} items available in stock",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void decreaseQuantity() {
    int minQuantity = product.minimumOrderQuantity ?? 1;
    if (quantity.value > minQuantity) {
      quantity.value--;
    } else {
      Get.snackbar(
        "Minimum Quantity",
        "Minimum order quantity is $minQuantity",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void toggleFavorite() {
    favoritesController.toggleFavorite(product);
    // Force UI update
    update();
  }

  void addToCart() {
    if ((product.stock ?? 0) <= 0) {
      Get.snackbar(
        "Out of Stock",
        "This product is currently out of stock",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Add to cart logic here
    Get.snackbar(
      "Added to Cart",
      "${quantity.value} x ${product.title} added to cart",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
    
    print("Added to cart: ${quantity.value} x ${product.title}");
    // You can implement actual cart logic here
    // For example: CartService.addToCart(product, quantity.value);
  }

  void goToReviews() {
    // Navigate to reviews screen
    Get.snackbar(
      "Reviews",
      "Navigate to reviews screen",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void shareProduct() {
    // Implement share functionality
    Get.snackbar(
      "Share",
      "Share ${product.title}",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}