import 'package:rabka_movie/provider/drawer_toggle_provider.dart';
import 'package:rabka_movie/utils/colors.dart';
import 'package:rabka_movie/widgets/home/continue_watching.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    bool _toggleValue = Provider.of<DrawerToggleProvider>(context).toggleValue;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: _toggleValue == true ? Colors.black87 : bgPrimaryColor,
          child: const Column(
            children: [
              SizedBox(height: 10),
              ContinueWatching(),
              SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}
