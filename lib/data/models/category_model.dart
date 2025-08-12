class CategoryModel {
  final String slug;
  final String name;
  final String image;

  CategoryModel({
    required this.slug,
    required this.name,
    required this.image,
  });

  factory CategoryModel.fromSlugAndImage(String slug, String image) {
    return CategoryModel(
      slug: slug,
      name: _capitalize(slug),
      image: image,
    );
  }

  static String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
