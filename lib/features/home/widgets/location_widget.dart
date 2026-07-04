import 'package:coffie_shop/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LocationWidget extends StatelessWidget {
  final String? userName;
  const LocationWidget({super.key, this.userName});

  @override
  Widget build(BuildContext context) {
    final hasUser = userName != null && userName!.trim().isNotEmpty;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: MyAppColor.primaryColor, size: 16),
                const SizedBox(width: 4),
                Text(hasUser ? "Welcome back" : "Location",
                    style: MyTexeStyle.subTitleText(size: 13)),
              ],
            ),
            const SizedBox(height: 4),
            Text(hasUser ? userName! : "Bilzen, Tanjungbalai",
                style: MyTexeStyle.smallTitleText(color: Colors.white, size: 16)),
          ],
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.15),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
        ),
      ],
    );
  }
}
