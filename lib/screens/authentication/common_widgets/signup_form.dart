import 'package:aptech_project/components/textField_widget.dart';
import 'package:aptech_project/provider/firebase_provider.dart';
import 'package:aptech_project/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:aptech_project/components/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




class SignupForm extends ConsumerStatefulWidget {
  const SignupForm({super.key});

  @override
  ConsumerState<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp(BuildContext context) async{
     if (!_formKey.currentState!.validate()) return;

     setState(() {
      _isLoading = true;
    });
    try{
        final firebaseService = ref.read(firebaseServiceProvider);
    
    print('starting sign up');
      final res = await firebaseService.signUp(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim()
      );

    print(res);
    // print('sign up completed!!');
     setState(() {
      _isLoading = false;
    });

     if (res == null) {
      if (!mounted) return;
      // Navigate to the Login screen
      print('sign up completed i guess');
      // Navigator.pushNamed(context, '/onboarding');
    }else{
      // ToasterUtils.showCustomSnackBar(context, errorMessage);
       showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Already Registered'),
      content: Text('This email is already in use. Would you like to log in instead?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Text('Go to Login'),
        ),
      ],
    ),
  );
      print('sign up might had failed');
    }
    }catch(e, stack){
      print('error during sign up $e');
      print('Stack trace: $stack');
    } finally{
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
          children: [
            TextfieldWidget(
                placeholder: 'Full name',
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }  
                  if (value.split(" ").length < 2) {
                    return 'Please enter at least two words for your full name';
                  }
                  return null;
                },
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                  size: 21,
                )
              ),
              const SizedBox(height:20),

                  TextfieldWidget(
                placeholder: 'Email',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                   if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
                },
                prefixIcon: const Icon(
                  Icons.alternate_email,
                  color: Colors.grey,
                  size: 21,
                )
              ),
            const SizedBox(height: 20),
             TextfieldWidget(
                placeholder: 'Password',
                controller: passwordController,
                isPassword: true,
                validator: (value) {
                       if (value == null || value.isEmpty) {
                return 'Please enter your password';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
                },
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Colors.grey,
                  size: 21,
                )
              ),
               const SizedBox(height: 20),

               
          CustomButton(
            onPressed: () {
              _signUp(context);
            },
            buttonText: "Register now",
            isLoading: _isLoading,
          ),
          ],
        ),
        )
        );
  }
}
