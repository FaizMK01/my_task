import 'package:get/get.dart';

class FavoritesController extends GetxController {
  static FavoritesController get instance => Get.find<FavoritesController>();
  
  var favorites = <dynamic>[].obs;
  var isLoading = false.obs;
  var searchQuery = "".obs;

  // Reactive filtered favorites based on searchQuery
  List<dynamic> get filteredFavorites {
    if (searchQuery.value.isEmpty) {
      return favorites;
    } else {
      return favorites.where((product) => 
        (product.title?.toLowerCase() ?? '').contains(searchQuery.value.toLowerCase()) ||
        (product.brand?.toLowerCase() ?? '').contains(searchQuery.value.toLowerCase()) ||
        (product.category?.toLowerCase() ?? '').contains(searchQuery.value.toLowerCase())
      ).toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void loadFavorites() {
    try {
      isLoading.value = true;
      // Here you can load favorites from local storage or API
      // For now, we'll keep the in-memory favorites
    } catch (e) {
      print("Error loading favorites: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  bool isFavorite(dynamic product) {
    return favorites.any((fav) => fav.id == product.id);
  }

  void addToFavorites(dynamic product) {
    if (!isFavorite(product)) {
      favorites.add(product);
      Get.snackbar(
        "Added to Favorites",
        "${product.title} has been added to your favorites",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
        duration: Duration(seconds: 2),
      );
    }
  }

  void removeFromFavorites(dynamic product) {
    favorites.removeWhere((fav) => fav.id == product.id);
    Get.snackbar(
      "Removed from Favorites",
      "${product.title} has been removed from your favorites",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: Duration(seconds: 2),
    );
  }

  void toggleFavorite(dynamic product) {
    if (isFavorite(product)) {
      removeFromFavorites(product);
    } else {
      addToFavorites(product);
    }
  }

  void clearAllFavorites() {
    favorites.clear();
    Get.snackbar(
      "Favorites Cleared",
      "All favorites have been removed",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
    );
  }
}