import 'package:evencir_task/data/models/products_model.dart';
import 'package:evencir_task/data/services/api_services.dart';
import 'package:get/get.dart';

class ProductByCategoryController extends GetxController {
  final String categorySlug;
  
  var products = <Product>[].obs;
  var isLoading = false.obs;
  var searchQuery = "".obs;
  var error = "".obs;

  ProductByCategoryController(this.categorySlug);

  // Reactive filtered products based on searchQuery
  List<Product> get filteredProducts {
    if (searchQuery.value.isEmpty) {
      return products;
    } else {
      return products.where((product) => 
        product.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        product.brand.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        product.description.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      isLoading.value = true;
      error.value = "";
      final data = await ApiService.getProductsByCategory(categorySlug);
      products.assignAll(data);
    } catch (e) {
      error.value = "Failed to load products: $e";
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}