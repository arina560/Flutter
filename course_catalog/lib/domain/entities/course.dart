class Course{
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final bool isBeginner;
  final bool isFavorite;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.isBeginner,
    this.isFavorite = false,
  });

  Course copyWith({bool? isFavorite}) {
    return Course(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      isBeginner: isBeginner,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}