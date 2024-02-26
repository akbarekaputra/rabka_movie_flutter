import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rabka_movie/provider/dark_mode_toggle_provider.dart';
import 'package:rabka_movie/resources/auth_methods.dart';
import 'package:rabka_movie/responsive/mobile_screen_layout.dart';
import 'package:rabka_movie/responsive/responsive_layout.dart';
import 'package:rabka_movie/responsive/web_screen_layout.dart';
import 'package:rabka_movie/screens/user/login_screen.dart';
import 'package:rabka_movie/utils/colors.dart';
import 'package:rabka_movie/widgets/text_field_input_widget.dart';
import 'package:rabka_movie/utils/utils.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    // If the user didn't select an image, use the default image link
    Uint8List imageBytes = _image ??
        await loadImageFromNetwork(
          'https://i.stack.imgur.com/l60Hf.png',
        );

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      file: imageBytes,
    );

    setState(() {
      _isLoading = false;
    });

    if (res == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      showSnackBar(context, res);
    }
  }

  Future<Uint8List> loadImageFromNetwork(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      // If the network image fails to load, you can handle it accordingly
      return Uint8List(0); // Empty bytes or some default image
    }
  }

  Future<void> selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    final toggleProvider = Provider.of<DarkModeToggleProvider>(context);
    bool _darkModeToggleValue = toggleProvider.toggleValue;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Back",
                    style: TextStyle(
                      color: _darkModeToggleValue
                          ? bgSecondaryColor
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
              Text(
                "Signup",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: _darkModeToggleValue ? bgSecondaryColor : Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                          backgroundColor: primaryColor,
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                            'https://i.stack.imgur.com/l60Hf.png',
                          ),
                          backgroundColor: primaryColor,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              TextFieldInputWidget(
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
              ),
              const SizedBox(height: 24),
              TextFieldInputWidget(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(height: 24),
              TextFieldInputWidget(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: primaryColor,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: bgPrimaryColor,
                        )
                      : const Text(
                          'Signup',
                          style: TextStyle(
                            color: bgPrimaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              const Spacer(flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: _darkModeToggleValue
                            ? bgSecondaryColor
                            : Colors.black,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Login.',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: _darkModeToggleValue
                              ? bgSecondaryColor
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
