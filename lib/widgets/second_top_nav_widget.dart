import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabka_movie/provider/dark_mode_toggle_provider.dart';
import 'package:rabka_movie/utils/colors.dart';

class SecondTopNavWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const SecondTopNavWidget({
    super.key,
    required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    bool toggleValue = Provider.of<DarkModeToggleProvider>(context).toggleValue;

    return AppBar(
      backgroundColor: toggleValue ? Colors.black87 : bgPrimaryColor,
      leading: _buildLeadingIcon(context, toggleValue),
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: toggleValue ? bgPrimaryColor : primaryColor,
        ),
      ),
      actions: <Widget>[
        _buildSearchIcon(toggleValue),
      ],
    );
  }

  Widget _buildLeadingIcon(BuildContext context, bool toggleValue) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: toggleValue ? bgPrimaryColor : primaryColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildSearchIcon(bool toggleValue) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: IconButton(
        icon: const Icon(Icons.search, size: 25),
        color: toggleValue ? bgPrimaryColor : primaryColor,
        onPressed: () {
          // Implement search functionality
        },
      ),
    );
  }
}
