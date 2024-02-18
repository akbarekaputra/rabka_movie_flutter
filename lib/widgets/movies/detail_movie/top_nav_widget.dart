import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabka_movie/models/movie_model.dart';
import 'package:rabka_movie/provider/drawer_toggle_provider.dart';
import 'package:rabka_movie/utils/colors.dart';

class TopNavWidget extends StatelessWidget implements PreferredSizeWidget {
  final Movie dataMovies;
  const TopNavWidget({Key? key, required this.dataMovies}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    bool _toggleValue = Provider.of<DrawerToggleProvider>(context).toggleValue;

    return AppBar(
      backgroundColor: _toggleValue ? Colors.black87 : bgPrimaryColor,
      leading: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: _toggleValue ? bgPrimaryColor : primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      title: Text(
        dataMovies.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: _toggleValue ? bgPrimaryColor : primaryColor,
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
            icon: const Icon(Icons.search, size: 25),
            color: _toggleValue ? bgPrimaryColor : primaryColor,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
