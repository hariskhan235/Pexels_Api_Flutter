class PhotoModel {
  late final int? id;
  final String title;
  final String image;

  PhotoModel({required this.title, required this.image, this.id});

  factory PhotoModel.fromMap(Map<String, dynamic> map) {
    return PhotoModel(title: map['title'], image: map['photo'], id: map['id']);
  }

  Map<String, Object?> toMap() => {'title': title, 'photo': image, 'id': id};
}
