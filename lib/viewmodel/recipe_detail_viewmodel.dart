import 'package:flutter/foundation.dart';
import '../core/error_handler.dart';
import '../data/model/recipe_model.dart';
import '../data/service/recipe_service.dart';

class RecipeDetailViewModel extends ChangeNotifier {
  final RecipeService _service = RecipeService();

  Recipe? _recipe;
  bool _isLoading = false;
  String? _error;

  Recipe? get recipe => _recipe;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRecipe(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _recipe = await _service.getRecipeById(id);
    } catch (e) {
      _error = ErrorHandler.getErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retry(int id) => fetchRecipe(id);
}