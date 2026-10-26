/// A book from the public catalog.
class Book {
  final String id;
  final String title;
  final String author;
  final String category;
  final int pageCount;
  final double rating;
  final int ratingCount;
  final String coverUrl;
  final String? summary;
  final bool isBestseller;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.pageCount,
    required this.rating,
    required this.ratingCount,
    required this.coverUrl,
    this.summary,
    this.isBestseller = false,
  });
}

enum BookCategory {
  all,
  selfDevelopment,
  history,
  literature,
  psychology,
  education,
}

extension BookCategoryExtension on BookCategory {
  String get label {
    switch (this) {
      case BookCategory.all:
        return 'الكل';
      case BookCategory.selfDevelopment:
        return 'تطوير الذات';
      case BookCategory.history:
        return 'تاريخي';
      case BookCategory.literature:
        return 'أدبي';
      case BookCategory.psychology:
        return 'علم النفس';
      case BookCategory.education:
        return 'تربية';
    }
  }

  /// Categories that appear as filter chips in the library screen.
  static List<BookCategory> get filters => [
        BookCategory.all,
        BookCategory.selfDevelopment,
        BookCategory.history,
        BookCategory.literature,
        BookCategory.psychology,
        BookCategory.education,
      ];
}
