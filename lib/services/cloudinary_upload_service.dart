import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryUploadService{

  Future<String?> uploadImageToCloudinary(XFile imageFile)async{
     final String cloudName = 'dbjehxk0f';
  final String uploadPreset = 'laptopHarbor';
  final String uploadUrl = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  try{
    final mimeType = imageFile.path.split('.').last;
    final bytes = await imageFile.readAsBytes();

     var request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
      ..fields['upload_preset'] = uploadPreset // Use the upload preset here
      ..files.add(http.MultipartFile.fromBytes('file', bytes, filename: 'upload.$mimeType'));

    var response = await request.send();

      if (response.statusCode == 200) {
      var responseData = await http.Response.fromStream(response);
      var jsonData = json.decode(responseData.body);
      return jsonData['secure_url']; // Cloudinary URL for the uploaded image
    } else {
      print('Failed to upload image: ${response.reasonPhrase}');
      return null;
    }
  }catch(e){
    print('error while uploading image $e');
    return null;
  }
  }
}