import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../data/model/recipe_model.dart';
import '../../viewmodel/recipe_detail_viewmodel.dart';
import '../widgets/error_view.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<RecipeDetailViewModel>().fetchRecipe(widget.recipeId);
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RecipeDetailViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return Center(
              child: Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_poqmycwy.json',
                width: 200,
                height: 200,
              ),
            );
          }
          if (vm.error != null) {
            return ErrorView(
              message: vm.error!,
              onRetry: () =>
                  context.read<RecipeDetailViewModel>().retry(widget.recipeId),
            );
          }
          return _buildContent(vm.recipe!);
        },
      ),
    );
  }

  Widget _buildContent(Recipe recipe) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(recipe.name,
                style: const TextStyle(fontSize: 14, shadows: [
                  Shadow(blurRadius: 6, color: Colors.black54)
                ])),
            background: Hero(
              tag: 'recipe-image-${recipe.id}',
              child: CachedNetworkImage(
                imageUrl: recipe.image,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.grey[300]),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(spacing: 8, runSpacing: 6, children: [
                    _chip(Icons.public, recipe.cuisine),
                    _chip(Icons.signal_cellular_alt, recipe.difficulty),
                    _chip(Icons.timer,
                        '${recipe.prepTimeMinutes + recipe.cookTimeMinutes} min'),
                    _chip(Icons.people, '${recipe.servings} servings'),
                    _chip(Icons.local_fire_department,
                        '${recipe.caloriesPerServing} kcal'),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    RatingBarIndicator(
                      rating: recipe.rating,
                      itemBuilder: (_, __) =>
                      const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 18,
                    ),
                    const SizedBox(width: 8),
                    Text('${recipe.rating} (${recipe.reviewCount} reviews)',
                        style: const TextStyle(color: Colors.grey)),
                  ]),
                  const SizedBox(height: 20),
                  _sectionTitle('Ingredients'),
                  ...recipe.ingredients.asMap().entries.map((e) =>
                      AnimatedOpacity(
                        opacity: 1.0,
                        duration: Duration(milliseconds: 200 + e.key * 50),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(children: [
                            const Icon(Icons.fiber_manual_record,
                                size: 8, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(child: Text(e.value)),
                          ]),
                        ),
                      )),
                  const SizedBox(height: 20),
                  _sectionTitle('Instructions'),
                  ...recipe.instructions.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text('${e.key + 1}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(e.value)),
                      ],
                    ),
                  )),
                  const SizedBox(height: 20),
                  _sectionTitle('Tags'),
                  Wrap(
                    spacing: 8,
                    children: recipe.tags
                        .map((t) => Chip(
                      label: Text(t,
                          style: const TextStyle(fontSize: 12)),
                      backgroundColor:
                      Colors.orange.withValues(alpha: 0.1),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(title,
        style:
        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );

  Widget _chip(IconData icon, String label) => Chip(
    avatar: Icon(icon, size: 14),
    label: Text(label, style: const TextStyle(fontSize: 12)),
    visualDensity: VisualDensity.compact,
  );
}