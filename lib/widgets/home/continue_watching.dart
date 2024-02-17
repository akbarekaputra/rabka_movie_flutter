import 'package:rabka_movie/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:rabka_movie/provider/drawer_toggle_provider.dart';
import 'package:provider/provider.dart';

class ContinueWatching extends StatelessWidget {
  const ContinueWatching({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _toggleValue = Provider.of<DrawerToggleProvider>(context).toggleValue;

    return SizedBox(
      height: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Continue Watching",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color:
                        _toggleValue == true ? bgPrimaryColor : Colors.black87,
                  ),
                ),
                Icon(
                  Icons.navigate_next,
                  color: _toggleValue == true ? bgPrimaryColor : primaryColor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            "assets/images/placeholder_16_9.png",
                            height: 90,
                            width: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Stack(
                            children: [
                              Container(
                                width: 160,
                                height: 3,
                                color: bgSecondaryColor,
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: 70,
                                  height: 3,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
