import 'dart:async';
import 'dart:core';

import 'package:photos_app/models/photo_model.dart';

import 'repository.dart';

class MemoryRepository extends Repository {
  final List<PhotoModel> _currentPhotos = <PhotoModel>[];

  //final List<Ingredient> _currentIngredients = <Ingredient>[];
  var photoIdCount = 0;
  Stream<List<PhotoModel>>? _photoStream;

  //Stream<List<Ingredient>>? _ingredientStream;
  final StreamController _photoStreamController =
      StreamController<List<PhotoModel>>.broadcast();

  //final StreamController _ingredientStreamController =
  //StreamController<List<Ingredient>>();

  @override
  Stream<List<PhotoModel>> watchAllPhotos() {
    _photoStream ??= _photoStreamController.stream as Stream<List<PhotoModel>>;
    return _photoStream!;
  }

  // @override
  // Stream<List<Ingredient>> watchAllIngredients() {
  //   _ingredientStream ??=
  //   _ingredientStreamController.stream as Stream<List<Ingredient>>;
  //   return _ingredientStream!;
  // }

  @override
  Future<List<PhotoModel>> findAllPhotos() {
    return Future.value(_currentPhotos);
  }

  // @override
  // Future<Recipe> findRecipeById(int id) {
  //   return Future.value(
  //       _currentRecipes.firstWhere((recipe) => recipe.id == id));
  // }

  // @override
  // Future<List<Ingredient>> findAllIngredients() {
  //   return Future.value(_currentIngredients);
  // }

  // @override
  // Future<List<Ingredient>> findRecipeIngredients(int recipeId) {
  //   final recipe =
  //   _currentRecipes.firstWhere((recipe) => recipe.id == recipeId);
  //   final recipeIngredients = _currentIngredients
  //       .where((ingredient) => ingredient.recipeId == recipe.id)
  //       .toList();
  //   return Future.value(recipeIngredients);
  // }

  @override
  Future<int> addToFavorites(PhotoModel photoModel) {
    photoModel.id = photoIdCount++;
    _currentPhotos.add(photoModel);
    _photoStreamController.sink.add(_currentPhotos);
    // if (photoModel.ingredients != null) {
    //   for (final ingredient in recipe.ingredients!) {
    //     ingredient.recipeId = recipe.id!;
    //   }
    //   insertIngredients(recipe.ingredients!);
    // }
    return Future.value(0);
  }

  // @override
  // Future<List<int>> insertIngredients(List<Ingredient> ingredients) {
  //   if (ingredients.isNotEmpty) {
  //     _currentIngredients.addAll(ingredients);
  //     _ingredientStreamController.sink.add(_currentIngredients);
  //   }
  //   return Future.value(<int>[]);
  // }

  @override
  Future<void> deletePhoto(PhotoModel photoModel) {
    _currentPhotos.remove(photoModel);
    _photoStreamController.sink.add(_currentPhotos);
    if (photoModel.id != null) {
      //deleteRecipeIngredients(recipe.id!);
    }
    return Future.value();
  }

  // @override
  // Future<void> deleteIngredient(Ingredient ingredient) {
  //   _currentIngredients.remove(ingredient);
  //   _ingredientStreamController.sink.add(_currentIngredients);
  //   return Future.value();
  // }

  // @override
  // Future<void> deleteIngredients(List<Ingredient> ingredients) {
  //   _currentIngredients
  //       .removeWhere((ingredient) => ingredients.contains(ingredient));
  //   _ingredientStreamController.sink.add(_currentIngredients);
  //   return Future.value();
  // }
  // @override
  // Future<void> deleteRecipeIngredients(int recipeId) {
  //   _currentIngredients
  //       .removeWhere((ingredient) => ingredient.recipeId == recipeId);
  //   _ingredientStreamController.sink.add(_currentIngredients);
  //   return Future.value();
  // }

  @override
  Future init() {
    return Future.value();
  }

  @override
  void close() {
    _photoStreamController.close();
    // _ingredientStreamController.close();
  }

// @override
// Future<int> addToFavorites(PhotoModel photoModel) {
//   // TODO: implement addToFavorites
//   throw UnimplementedError();
// }
}
