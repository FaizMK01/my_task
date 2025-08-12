import 'package:evencir_task/data/models/category_model.dart';
import 'package:evencir_task/data/services/api_services.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  var categories = <CategoryModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = "".obs;

  // Reactive filtered categories based on searchQuery
  List<CategoryModel> get filteredCategories {
    if (searchQuery.value.isEmpty) {
      return categories;
    } else {
      return categories.where((cat) => 
        cat.name.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      isLoading.value = true;
      final data = await ApiService.fetchCategoriesFast();
      categories.assignAll(data);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void goToProducts(String slug) {
    Get.toNamed('/products', arguments: slug);
  }
}