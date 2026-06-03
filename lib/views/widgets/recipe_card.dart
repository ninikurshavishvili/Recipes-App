import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../data/model/recipe_model.dart';


class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeCard({super.key, required this.recipe, required this.onTap});

  Color _difficultyColor(String d) => switch (d.toLowerCase()) {
    'easy' => Colors.green,
    'medium' => Colors.orange,
    _ => Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 150),
        child: Card(
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          elevation: 3,
          child: Row(
            children: [
              Hero(
                tag: 'recipe-image-${recipe.id}',
                child: CachedNetworkImage(
                  imageUrl: recipe.image,
                  width: 110,
                  height: 120,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: Colors.grey[200]),
                  errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.public, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(recipe.cuisine,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _difficultyColor(recipe.difficulty)
                                .withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(recipe.difficulty,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: _difficultyColor(recipe.difficulty),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ]),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.timer, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                            '${recipe.prepTimeMinutes + recipe.cookTimeMinutes} min',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                        const SizedBox(width: 10),
                        const Icon(Icons.local_fire_department,
                            size: 12, color: Colors.deepOrange),
                        const SizedBox(width: 4),
                        Text('${recipe.caloriesPerServing} kcal',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ]),
                      const SizedBox(height: 4),
                      RatingBarIndicator(
                        rating: recipe.rating,
                        itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}