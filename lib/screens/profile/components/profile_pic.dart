import 'package:aptech_project/services/auth_services.dart';
import 'package:aptech_project/services/cloudinary_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    super.key,
    required this.image,
    this.isShowPhotoUpload = false,
    this.imageUploadBtnPress,
  });

  final String image;
  final bool isShowPhotoUpload;
  final VoidCallback? imageUploadBtnPress;

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  final ImagePicker _picker = ImagePicker();
  String? _profileImageUrl;
   bool _isUploading = false;

    @override
  void initState() {
    super.initState();
  }
  Future<void> _pickImage() async {
      try{
            final XFile? pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Take Photo"),
              onTap: () async {
                final photo = await _picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context, photo);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Choose from Gallery"),
              onTap: () async {
                final image = await _picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context, image);
              },
            ),
          ],
        ),
      ),
    );

    if (pickedFile != null) {
       setState(() {
          _isUploading = true;
        });

      final imageUrl = await CloudinaryUploadService().uploadImageToCloudinary(pickedFile);
      if (imageUrl != null) {
        await _updateUserPhoto(imageUrl);
        setState(() {
          _profileImageUrl = imageUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image upload failed')),
        );
      }
       setState(() {
          _isUploading = false;
        });
    }
      }catch(e){
        setState(() {
        _isUploading = false;
      });
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image upload failed: $e')),
        );
      }
  }
  Future<void> _updateUserPhoto(String imageUrl) async {
    try{
      final res = await AuthService().updateUserPhoto(imageUrl);
      print('profile image upload: $res');
      
    }catch(e){
      print('error while uploading image to firestore: $e');
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image upload failed: $e')),
        );
    }
  }
  @override
  Widget build(BuildContext context) {
    if (_isUploading) {
      return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );

    }
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.08),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(_profileImageUrl ?? widget.image),
          ),
          InkWell(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 13,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}