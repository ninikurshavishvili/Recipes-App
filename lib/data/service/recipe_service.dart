import 'package:dio/dio.dart';
import '../model/recipe_model.dart';
import 'client.dart';
import '../../core/api_constants.dart';

class RecipeService {
  final Dio _dio = DioClient().client;

  Future<List<Recipe>> getRecipes({int limit = 30, int skip = 0}) async {
    final response = await _dio.get(
      ApiConstants.recipes,
      queryParameters: {'limit': limit, 'skip': skip},
    );
    final List data = response.data['recipes'];
    return data.map((e) => Recipe.fromJson(e)).toList();
  }

  Future<Recipe> getRecipeById(int id) async {
    final response = await _dio.get(ApiConstants.recipeById(id));
    return Recipe.fromJson(response.data);
  }
}