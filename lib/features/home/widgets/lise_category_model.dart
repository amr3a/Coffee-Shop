import 'package:coffie_shop/core/models/category_model.dart';
import 'package:coffie_shop/core/shared/buttons.dart';
import 'package:coffie_shop/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class MyListCategory extends StatefulWidget {
  const MyListCategory({super.key});

  @override
  State<MyListCategory> createState() => _MyListCategoryState();
}

class _MyListCategoryState extends State<MyListCategory> {
  List<CategoryModel> categories = [
    CategoryModel(id: 1, name: "All Coffee"),
    CategoryModel(id: 2, name: "Machiato"),
    CategoryModel(id: 3, name: "Latte"),
    CategoryModel(id: 4, name: "Americano"),

  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView.separated(//الفصل بين كل عنصر وعنصر
        separatorBuilder: (context, index) => SizedBox(width: 16,),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {

          return MyCategoryButton(
          isSelected: selectedIndex == index,
          onTap: (){
            setState(() {
              selectedIndex = index;
            });
          }
          ,category: categories[index]);
        }

      ),
    );
  }
}


