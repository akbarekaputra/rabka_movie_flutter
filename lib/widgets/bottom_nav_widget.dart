import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabka_movie/provider/dark_mode_toggle_provider.dart';
import 'package:rabka_movie/utils/colors.dart';

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget({
    super.key,
    required this.currentPage,
    required this.navItems,
    required this.onTap,
  });

  final int currentPage;
  final List<Map<String, dynamic>> navItems;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final toggleProvider = Provider.of<DarkModeToggleProvider>(context);
    final bool toggleValue = toggleProvider.toggleValue;

    final Color _primaryColor = toggleValue ? bgPrimaryColor : primaryColor;
    final Color _secondaryColor = toggleValue ? secondaryColor : secondaryColor;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: BottomAppBar(
          color: toggleValue
              ? Colors.black87.withOpacity(0.5)
              : bgPrimaryColor.withOpacity(0.5),
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              for (int index = 0; index < navItems.length; index++)
                GestureDetector(
                  onTap: () {
                    onTap(index);
                  },
                  child: Column(
                    children: [
                      Icon(
                        navItems[index]["icon"],
                        color: currentPage == index
                            ? _primaryColor
                            : _secondaryColor,
                      ),
                      Text(
                        navItems[index]["page"],
                        style: TextStyle(
                          color: currentPage == index
                              ? _primaryColor
                              : _secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
