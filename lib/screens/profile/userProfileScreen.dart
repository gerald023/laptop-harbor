import 'package:flutter/material.dart';


class Userprofilescreen extends StatefulWidget {
  const Userprofilescreen({super.key});

  @override
  State<Userprofilescreen> createState() => _UserprofilescreenState();
}

class _UserprofilescreenState extends State<Userprofilescreen> {
  String name = 'Naila Stefenson';
  String role = 'UX/UI Designer';
  String currentImage = 'assets/profile.jpg';

  void _toggleImage() {
    // Simulates switching profile image from assets
    setState(() {
      currentImage = currentImage == 'assets/profile.jpg'
          ? 'assets/profile2.jpg'
          : 'assets/profile.jpg';
    });
  }

  void _editProfile() {
    final nameController = TextEditingController(text: name);
    final roleController = TextEditingController(text: role);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: roleController, decoration: const InputDecoration(labelText: 'Role')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                name = nameController.text;
                role = roleController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  void _changePassword() {
    final oldPass = TextEditingController();
    final newPass = TextEditingController();
    final confirmPass = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: oldPass, obscureText: true, decoration: const InputDecoration(labelText: "Old Password")),
            TextField(controller: newPass, obscureText: true, decoration: const InputDecoration(labelText: "New Password")),
            TextField(controller: confirmPass, obscureText: true, decoration: const InputDecoration(labelText: "Confirm Password")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (newPass.text == confirmPass.text) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed successfully')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  Widget buildListTile(IconData icon, String title, {VoidCallback? onTap, Widget? trailing}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: CurvedClipper(),
                child: Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.purple, Colors.deepPurple]),
                  ),
                ),
              ),
              const Positioned(
                top: 60,
                left: 20,
                child: Icon(Icons.menu, color: Colors.white, size: 28),
              ),
              Positioned(
                top: 100,
                left: MediaQuery.of(context).size.width / 2 - 50,
                child: GestureDetector(
                  onTap: _toggleImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage(currentImage),
                      child: const Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 13,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit, size: 16, color: Colors.purple),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(role, style: const TextStyle(color: Colors.grey)),
          TextButton(onPressed: _editProfile, child: const Text('Edit Profile')),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                buildListTile(Icons.person, 'My Profile'),
                buildListTile(Icons.mail, 'Messages', trailing: badge(7)),
                buildListTile(Icons.favorite, 'Favourites'),
                buildListTile(Icons.location_on, 'Location'),
                buildListTile(Icons.settings, 'Settings'),
                buildListTile(Icons.lock, 'Change Password', onTap: _changePassword),
                const Divider(),
                buildListTile(Icons.logout, 'Logout'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget badge(int count) {
    return CircleAvatar(
      radius: 10,
      backgroundColor: Colors.purple,
      child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 60);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 60);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}