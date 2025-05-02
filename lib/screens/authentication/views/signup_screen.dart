import 'package:aptech_project/screens/authentication/common_widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aptech_project/route/route_constants.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/signup";
  final _formKey = GlobalKey<FormState>();

  SignUpScreen({super.key});

   Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    // if (_formKey.currentState!.validate()) {
    //   _formKey.currentState!.save();
    // }
    Get.offNamed('/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Image.network(
                  "https://i.postimg.cc/CxTcnYG2/Laptop-Harbor-Logo.png",
                  height: 200,
                    width: 200,
                ),
                const SizedBox(height: 10),
                Text(
                  "Sign Up",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      
                      const SizedBox(height: 16.0),
                      const SignupForm(),
                       const SizedBox(height: 10.0),
                      Center(
                        child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account?'),
                          const SizedBox(width: 1),
                          TextButton(
                        onPressed: () {
                          // Get.offNamed('login');
                          Navigator.pushNamed(context, logInScreenRoute);
                        },
                        child: Text.rich(
                          const TextSpan(
                            children: [
                              TextSpan(
                                text: "Sign in",
                                style: TextStyle(color: Color(0xFF00BF6D)),
                              ),
                            ],
                          ),
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(0.64),
                                  ),
                        ),
                      ),
                        ],
                      ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// only for demo
List<DropdownMenuItem<String>>? countries = [
  "Bangladesh",
  "Switzerland",
  'Canada',
  'Japan',
  'Germany',
  'Australia',
  'Sweden',
].map<DropdownMenuItem<String>>((String value) {
  return DropdownMenuItem<String>(value: value, child: Text(value));
}).toList();
