import 'package:flutter/foundation.dart';
import '../data/model/recipe_model.dart';
import '../data/service/recipe_service.dart';


class RecipeListViewModel extends ChangeNotifier {
  final RecipeService _service = RecipeService();

  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String? _error;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRecipes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _recipes = await _service.getRecipes();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}