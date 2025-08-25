import 'dart:io';

class Advertisement {
  final String title;
  final String category;
  final String description;
  final double? price;
  final File? image;
  final DateTime date;

  Advertisement({
    required this.title,
    required this.category,
    required this.description,
    this.price,
    this.image,
    required this.date,
  });
}
