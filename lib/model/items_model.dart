

enum Category { vegetable, fruit, meat, other }

class ItemsModel {
  ItemsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final Category category;
}