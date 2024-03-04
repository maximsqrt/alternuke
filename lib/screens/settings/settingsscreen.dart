import 'dart:io';
import 'package:alertnukeapp/config/colors.dart';
import 'package:alertnukeapp/features/authentication/application/authentication_login_service.dart';
import 'package:alertnukeapp/features/icons/domain/firebase_image.dart';
import 'package:alertnukeapp/screens/home/profilepic.dart';
import 'package:alertnukeapp/screens/settings/applications.dart/applications.dart';
import 'package:flutter/material.dart';
import 'package:alertnukeapp/application/FirebaseUserData.dart';
import 'package:icony/icony_ikonate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

///For Name, Phone, Mail
class EditableField extends StatelessWidget {
  final String label;
  final String? value;

  const EditableField({super.key, required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, color: FancyFontColor.primaryColor),
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: value,
        ),
      ],
    );
  }
}

class ImagePickerService {
  //Methode zur Bildwahl
  Future<File?> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    //RUfe Pickimage auf und warte 
    return pickedImage != null ? File(pickedImage.path) : null;
  }
}
class SettingsScreen extends StatefulWidget {
  
  
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();

}
class _SettingsScreenState extends State<SettingsScreen> {
  late String userId; // userId als nullable Variable deklariert
  String downloadUrl = '';
  late ProfilePictureProvider _profilePictureProvider; // Hier die Variable deklarieren

  @override
  void initState() {
    super.initState();
    ///1) initialise User
    userId = AuthenticationLoginService().getUserId() ?? "";
    print("UserID: $userId");
    ///2) get ProfilePicture URL 
    _fetchProfilePictureUrl().then((_) {
      /// 3) call Provider for ProfilePic Provider
      _profilePictureProvider = Provider.of<ProfilePictureProvider>(context, listen: false);
      ///4. Profilpictue-URL
      _profilePictureProvider.updateProfilePictureUrl(downloadUrl);
    });
  }
 Future<void> _fetchProfilePictureUrl() async {
  ///get ProfilPic Url
    String? url = await FirebaseImageStorageService().getProfilePictureUrl(userId);
    //check if URL is not null
    if (url != null) {
      setState(() {
        downloadUrl = url;
      });
    } else {
      // Handle error when URL is null
      print("Error occurred while fetching profile picture URL");
    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
   _profilePictureProvider = Provider.of<ProfilePictureProvider>(context, listen: false);
    _fetchProfilePictureUrl(); 
  }

  

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Container(
        decoration: BoxDecoration(
          gradient: SettingsBackgroundColor.linearGradient(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ignore: avoid_unnecessary_containers
            Container(child: ProfilePictureWidget(userId: userId)),
              
              
              const SizedBox(height: 20),
              const Text(
                'Your Fancy Profile',
                style: TextStyle(fontSize: 20, color: FancyFontColor.primaryColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              EditableField(label: 'Name:', value: FirebaseUserData.username), // Use your FirebaseUserData here
              const SizedBox(height: 10),
              const EditableField(label: 'Phone Number:', value: ''), // Provide phone number value if available
              const SizedBox(height: 10),
              EditableField(label: 'Email Address:', value: FirebaseUserData.email), // Use your FirebaseUserData here
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()  {  showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return ProfilePicScreen();
              },
            );
        },
        child: const Ikonate(Ikonate.image),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Save'),
    );
  }
}



// ignore: unused_element, camel_case_types
class _bottomSheet extends StatelessWidget {
  const _bottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('Show Modal BottomSheet'),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return ProfilePicScreen();
            },
          );
        },
      ),
    );
  }
}