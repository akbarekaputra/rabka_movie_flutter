import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabka_movie/provider/dark_mode_toggle_provider.dart';
import 'package:rabka_movie/responsive/mobile_screen_layout.dart';
import 'package:rabka_movie/responsive/responsive_layout.dart';
import 'package:rabka_movie/responsive/web_screen_layout.dart';
import 'package:rabka_movie/screens/user/signup_screen.dart';
import 'package:rabka_movie/resources/auth_methods.dart';
import 'package:rabka_movie/utils/colors.dart';
import 'package:rabka_movie/utils/utils.dart';
import 'package:rabka_movie/widgets/text_field_input_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res == 'success') {
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

    setState(() {
      _isLoading = false;
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
              const Spacer(),
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: _darkModeToggleValue ? bgSecondaryColor : Colors.black,
                ),
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
              const SizedBox(height: 24),
              InkWell(
                onTap: _isLoading ? null : _loginUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: primaryColor,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: bgPrimaryColor)
                      : const Text(
                          'Sign in',
                          style: TextStyle(
                            color: bgPrimaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: _darkModeToggleValue
                            ? bgSecondaryColor
                            : Colors.black,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Signup.',
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
