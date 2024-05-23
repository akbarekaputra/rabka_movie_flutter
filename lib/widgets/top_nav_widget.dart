import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';
import 'package:rabka_movie/provider/dark_mode_toggle_provider.dart';
import 'package:rabka_movie/utils/colors.dart';

class TopNavWidget extends StatelessWidget implements PreferredSizeWidget {
  final AdvancedDrawerController advancedDrawerController;

  const TopNavWidget({
    Key? key,
    required this.advancedDrawerController,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    bool toggleValue = Provider.of<DarkModeToggleProvider>(context).toggleValue;

    return AppBar(
      backgroundColor: toggleValue ? Colors.black87 : bgPrimaryColor,
      title: Text(
        'Rabka Movie',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: toggleValue ? bgPrimaryColor : primaryColor,
        ),
      ),
      centerTitle: false,
      leading: _buildLeadingIcon(context, toggleValue),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
            icon: const Icon(Icons.search, size: 25),
            color: toggleValue ? bgPrimaryColor : primaryColor,
            onPressed: () {
              // Implement search functionality
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLeadingIcon(BuildContext context, bool toggleValue) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: IconButton(
        icon: ValueListenableBuilder<AdvancedDrawerValue>(
          valueListenable: advancedDrawerController,
          builder: (_, value, __) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                value.visible ? Icons.clear : Icons.menu,
                key: ValueKey<bool>(value.visible),
                color: toggleValue ? bgPrimaryColor : primaryColor,
              ),
            );
          },
        ),
        onPressed: () {
          advancedDrawerController.showDrawer();
        },
      ),
    );
  }
}
