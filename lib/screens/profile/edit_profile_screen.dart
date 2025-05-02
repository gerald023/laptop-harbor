import 'package:aptech_project/models/userModel.dart';
import 'package:aptech_project/route/route_constants.dart';
import 'package:aptech_project/services/auth_services.dart';
import 'package:flutter/material.dart';
import './components/profile_pic.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
 

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserModel? userModel;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
  


  Future<void> getUserProfile() async{
    try{
      final res = await AuthService().getCurrentUserModel();
      setState(() {
        userModel = res;
        emailController.text = res!.email;
        nameController.text = res.name;
      });
    }catch(e){
      print('error in getting profile: $e');
    }
  }
  @override
  void initState() {
    super.initState();
    getUserProfile();
  }
  Future<void> editProfile() async{
    try{
      setState(() {
        isLoading = true;
      });
      final res = await AuthService().updateUserProfile(
        name: nameController.text,
        email: emailController.text
      );
      if (res == 'profile updated') {
        ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Profile updated successfully!'),
      duration: Duration(seconds: 2),
    ),
  );
  Navigator.pushNamed(context, profileScreenRoute);
      }
      setState(() {
        isLoading = false;
      });
    }catch(e){
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
     if (userModel == null) {
      return const Center(
        child: CircularProgressIndicator(

        ),
      );
    }
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0x00000000),
        // foregroundColor: Colors.white,
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            ProfilePic(
              image: userModel!.profilePicture.toString(),
              imageUploadBtnPress: () {},
            ),
            const Divider(),
            Form(
              child: Column(
                children: [
                  UserInfoEditField(
                    text: "Name",
                    child: TextFormField(
                      controller: nameController,
                      // initialValue: userModel!.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                     
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                  UserInfoEditField(
                    text: "Email",
                    child: TextFormField(
                      // initialValue: userModel!.email,
                      controller: emailController,
                      validator: (value) {
                   if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
                },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                  // UserInfoEditField(
                  //   text: "Phone",
                  //   child: TextFormField(
                  //     initialValue: "(316) 555-0116",
                  //     decoration: InputDecoration(
                  //       filled: true,
                  //       fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                  //       contentPadding: const EdgeInsets.symmetric(
                  //           horizontal: 16.0 * 1.5, vertical: 16.0),
                  //       border: const OutlineInputBorder(
                  //         borderSide: BorderSide.none,
                  //         borderRadius: BorderRadius.all(Radius.circular(50)),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // UserInfoEditField(
                  //   text: "Address",
                  //   child: TextFormField(
                  //     initialValue: "New York, NVC",
                  //     decoration: InputDecoration(
                  //       filled: true,
                  //       fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                  //       contentPadding: const EdgeInsets.symmetric(
                  //           horizontal: 16.0 * 1.5, vertical: 16.0),
                  //       border: const OutlineInputBorder(
                  //         borderSide: BorderSide.none,
                  //         borderRadius: BorderRadius.all(Radius.circular(50)),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // UserInfoEditField(
                  //   text: "Old Password",
                  //   child: TextFormField(
                  //     obscureText: true,
                  //     initialValue: "demopass",
                  //     decoration: InputDecoration(
                  //       suffixIcon: const Icon(
                  //         Icons.visibility_off,
                  //         size: 20,
                  //       ),
                  //       filled: true,
                  //       fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                  //       contentPadding: const EdgeInsets.symmetric(
                  //           horizontal: 16.0 * 1.5, vertical: 16.0),
                  //       border: const OutlineInputBorder(
                  //         borderSide: BorderSide.none,
                  //         borderRadius: BorderRadius.all(Radius.circular(50)),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // UserInfoEditField(
                  //   text: "New Password",
                  //   child: TextFormField(
                  //     decoration: InputDecoration(
                  //       hintText: "New Password",
                  //       filled: true,
                  //       fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                  //       contentPadding: const EdgeInsets.symmetric(
                  //           horizontal: 16.0 * 1.5, vertical: 16.0),
                  //       border: const OutlineInputBorder(
                  //         borderSide: BorderSide.none,
                  //         borderRadius: BorderRadius.all(Radius.circular(50)),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, profileScreenRoute);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 16.0),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BF6D),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: isLoading ? null :() {
                      editProfile();
                    },

                    child:isLoading ? const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        )
        
        : const Text("Save Update"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



class UserInfoEditField extends StatelessWidget {
  const UserInfoEditField({
    super.key,
    required this.text,
    required this.child,
  });

  final String text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0 / 2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(text),
          ),
          Expanded(
            flex: 3,
            child: child,
          ),
        ],
      ),
    );
  }
}
