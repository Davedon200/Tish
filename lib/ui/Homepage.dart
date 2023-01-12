import 'package:flutter/material.dart';

import 'package:tish/ui/recipecard.dart';

import 'package:url_launcher/url_launcher.dart';

import '../model/recipe.api.dart';
import '../model/recipe.dart';


class First extends StatefulWidget {
  const First({Key? key}) : super(key: key);

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
 late List<Recipe> _recipes ;
  bool _isLoading = true;



  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  Future<void> getRecipes() async {
    _recipes = await RecipeApi.getRecipe();
    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  const [
            Icon(Icons.restaurant, color: Colors.black,),
            SizedBox(width: 10.0,),
            Text('FOOD RECIPE',style: TextStyle(color: Colors.black),),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body:_isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          return RecipeCard(
                  title: _recipes[index].name,
                  cookTime: _recipes[index].totalTime,
                  rating: _recipes[index].rating.toString(),
                  thumbnailUrl: _recipes[index].images,
                  ontapped: () async{
                    final Uri url = Uri.parse(_recipes[index].directionurl);
                    if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
                    throw 'Could not launch $url';
                    }
                  }
          );
        },
      ),
    );

    }



  }
