import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/views/screens/recipe_detail_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../viewmodel/recipe_list_viewmodel.dart';
import '../widgets/recipe_card.dart';


class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<RecipeListViewModel>().fetchRecipes();
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<RecipeListViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) return _buildShimmer();
          if (vm.error != null) {
            return Center(child: Text('Error: ${vm.error}'));
          }
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final recipe = vm.recipes[index];
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300 + index * 30),
                  curve: Curves.easeOut,
                  child: RecipeCard(
                    recipe: recipe,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailScreen(recipeId: recipe.id),
                      ),
                    ),
                  ),
                );
              },
              itemCount: vm.recipes.length,
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 8,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}