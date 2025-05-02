import 'package:aptech_project/components/custom_button.dart';
import 'package:aptech_project/models/userModel.dart';
import 'package:aptech_project/route/route_constants.dart';
import 'package:aptech_project/services/auth_services.dart';
import 'package:flutter/material.dart';
import './components/profile_pic.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? userModel;

  Future<void> getUserProfile() async{
    try{
      final res = await AuthService().getCurrentUserModel();
      setState(() {
        userModel = res;
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
        title: const Text("Profile"),
        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
             ProfilePic(image: userModel!.profilePicture.toString()),
            Text(
              userModel!.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(height: 16.0 * 2),
             Info(
              infoKey: "User ID",
              info: "@${userModel!.name}",
            ),
            const Info(
              infoKey: "Location",
              info: "New York, NYC",
            ),
            Info(
              infoKey: "Email Address",
              info: userModel!.email,
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 160,
                child: CustomButton(
                  onPressed: (){
                    Navigator.pushNamed(context, editProfileScreenRoute,);
                  }, 
                  buttonText: 'Edit Profile',
                  backgroundColor: Colors.black,
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Info extends StatelessWidget {
  const Info({
    super.key,
    required this.infoKey,
    required this.info,
  });

  final String infoKey, info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            infoKey,
            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withOpacity(0.8),
            ),
          ),
          Text(info),
        ],
      ),
    );
  }
}
