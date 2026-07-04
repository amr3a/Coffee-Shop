import 'package:coffie_shop/core/constants/image_constiant.dart';
import 'package:coffie_shop/core/models/category_model.dart';
import 'package:coffie_shop/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class MyGenrallButton extends StatelessWidget {
  final String name;
  final Function()? onPressed;
  const MyGenrallButton({
    super.key, required this.onPressed,required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 56,

      color: MyAppColor.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),

      ),
      onPressed: onPressed,
      child: Text(name
        ,style: MyTexeStyle.normalTitleText(
          color: Colors.white,

        ),),
    );
  }
}



class MyIconButton extends StatelessWidget {
  final String icon;
  final Function()? onTap;
  const MyIconButton({
    super.key,required this.icon,required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 52,
        width: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: MyAppColor.primaryColor,

        ),
        child: Image.asset(icon,color: Colors.white,height: 20,width: 20,),
      ),
    );
  }
}



class MyCategoryButton extends StatelessWidget {
  final bool isSelected;
  final Function() onTap;
  const MyCategoryButton({
    super.key,required this.isSelected,required this.onTap,
    required this.category,
  });

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,


        padding: EdgeInsets.all(4),

        decoration: BoxDecoration(
          color: isSelected? MyAppColor.primaryColor :Color(0xffEDEDED).withAlpha(300) ,
          borderRadius: BorderRadius.circular(12),

        ),
        child: Text(category.name,style:isSelected? MyTexeStyle.normalTitleText(color: Colors.white) :MyTexeStyle.normalTitleText(size: 14) ,),
      ),
    );
  }
}





class ButtonSizeCoffeeWidget extends StatelessWidget {
  final String size;
  final bool isSelected; // خاصية جديدة لمعرفة حالة الزر
  final VoidCallback onTap;  const ButtonSizeCoffeeWidget({
    super.key,
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            // تغيير اللون الخلفي: إذا كان مختاراً يصبح بني، وإذا لا يصبح رمادي فاتح
            color: isSelected ? MyAppColor.dividerColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              // تغيير لون الإطار أيضاً
              color: isSelected ? Colors.brown : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            size,
            style: MyTexeStyle.normalTitleText(size: 18).copyWith(
              // تغيير لون النص: أبيض إذا كان مختاراً، وأسود إذا لا
              color: isSelected ? Colors.brown : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}