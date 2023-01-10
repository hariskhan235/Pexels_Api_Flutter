import 'package:photos_app/models/photo_model.dart';

abstract class Repository {
  Future<List<PhotoModel>> findAllPhotos();

  Stream<List<PhotoModel>> watchAllPhotos();

  Future<int> addToFavorites(PhotoModel photoModel);

  Future<void> deletePhoto(PhotoModel photoModel);

  Future init();

  void close();
}
