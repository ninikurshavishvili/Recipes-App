import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/viewmodel/recipe_detail_viewmodel.dart';
import 'package:recipes_app/viewmodel/recipe_list_viewmodel.dart';
import 'package:recipes_app/views/screens/recipe_list_screen.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeListViewModel()),
        ChangeNotifierProvider(create: (_) => RecipeDetailViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepOrange,
        useMaterial3: true,
      ),
      home: const RecipeListScreen(),
    );
  }
}