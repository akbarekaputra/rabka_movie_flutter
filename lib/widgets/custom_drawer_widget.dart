import 'package:rabka_movie/screens/login_screen.dart';
import 'package:rabka_movie/screens/my_account_screen.dart';
import 'package:rabka_movie/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabka_movie/provider/drawer_toggle_provider.dart';
import 'package:rabka_movie/utils/colors.dart';

class CustomDrawerWidget extends StatefulWidget {
  const CustomDrawerWidget({Key? key}) : super(key: key);

  @override
  State<CustomDrawerWidget> createState() => _CustomDrawerWidgetState();
}

class _CustomDrawerWidgetState extends State<CustomDrawerWidget> {
  bool isLoading = false;
  var userData = {};
  String uid = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      uid = FirebaseAuth.instance.currentUser!.uid;

      var userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      userData = userSnap.data()!;
      setState(() {});
    } catch (e) {
      e.toString() != "Null check operator used on a null value"
          ? showSnackBar(
              context,
              e.toString(),
            )
          : null;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final toggleProvider = Provider.of<DrawerToggleProvider>(context);
    bool _toggleValue = toggleProvider.toggleValue;

    return isLoading
        ? Container(
            color: bgPrimaryColor,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SafeArea(
            child: Container(
              padding: const EdgeInsets.only(top: 20, left: 10),
              decoration: BoxDecoration(
                color: _toggleValue == true ? Colors.black87 : Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListTileTheme(
                textColor: Colors.black,
                iconColor: primaryColor,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: userData.isEmpty
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.all(20),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: _toggleValue
                                        ? bgSecondaryColor
                                        : primaryColor,
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyAccountScreen(
                                      userData: userData,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(20),
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundImage: NetworkImage(
                                        userData["photoUrl"],
                                      ),
                                      backgroundColor: primaryColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData["username"],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: _toggleValue
                                                ? bgSecondaryColor
                                                : Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            userData["email"],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: _toggleValue
                                                  ? bgSecondaryColor
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: secondaryColor,
                                  ),
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(right: 32),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              "Dark Mode",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: _toggleValue
                                    ? bgSecondaryColor
                                    : Colors.black,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: _toggleValue,
                            onChanged: (value) {
                              toggleProvider.setToggleValue(value);
                            },
                            trackOutlineColor: const MaterialStatePropertyAll(
                                bgSecondaryColor),
                            trackOutlineWidth:
                                const MaterialStatePropertyAll(0),
                            inactiveTrackColor: primaryColor,
                            activeTrackColor: bgPrimaryColor,
                            inactiveThumbColor: bgPrimaryColor,
                            thumbIcon: MaterialStatePropertyAll(_toggleValue
                                ? const Icon(Icons.dark_mode)
                                : const Icon(
                                    Icons.light_mode,
                                    color: primaryColor,
                                  )),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.download),
                      title: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Download",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: _toggleValue
                                      ? bgSecondaryColor
                                      : Colors.black,
                                ),
                              ),
                              Text(
                                "Watch videos offline",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _toggleValue
                                      ? bgSecondaryColor
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            color: secondaryColor,
                            onPressed: () {},
                            icon: const Icon(Icons.keyboard_arrow_right),
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.checklist),
                      title: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Watchlist",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: _toggleValue
                                      ? bgSecondaryColor
                                      : Colors.black,
                                ),
                              ),
                              Text(
                                "Watch videos offline",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _toggleValue
                                      ? bgSecondaryColor
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            color: secondaryColor,
                            onPressed: () {},
                            icon: const Icon(Icons.keyboard_arrow_right),
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.category),
                      title: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Genres",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: _toggleValue
                                      ? bgSecondaryColor
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            color: secondaryColor,
                            onPressed: () {},
                            icon: const Icon(Icons.keyboard_arrow_right),
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.help),
                      title: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Help",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: _toggleValue
                                      ? bgSecondaryColor
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            color: secondaryColor,
                            onPressed: () {},
                            icon: const Icon(Icons.keyboard_arrow_right),
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.settings),
                      title: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Settings",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: _toggleValue
                                      ? bgSecondaryColor
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            color: secondaryColor,
                            onPressed: () {},
                            icon: const Icon(Icons.keyboard_arrow_right),
                          )
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
