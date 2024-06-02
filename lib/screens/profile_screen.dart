import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_jarum/service/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
   Position? _currentPosition;
   bool isSignedIn = true;
    File? _image;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   String _currentAddress = 'Mendapatkan alamat...';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }


  Future<void> _pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);

    if (selectedImage != null) {
      setState(() {
        _image = File(selectedImage.path);
      });
    }
  }
  void signIn() {
    Navigator.pushNamed(context, '/signin');
  }

  void signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSignedIn', false);

    Navigator.pushNamed(context, '/signin');
  }

Future<void> _launchMaps(double latitude, double longitude) async {
    Uri googleUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    try {
      await launchUrl(googleUrl);
    } catch (e) {
      print('Could not open the map: $e');
      
    }
  }

Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
     
      String fileName = 'profiles/${DateTime.now().millisecondsSinceEpoch}.png';
      UploadTask uploadTask = _storage.ref().child(fileName).putFile(_image!);
      TaskSnapshot snapshot = await uploadTask;

      String downloadURL = await snapshot.ref.getDownloadURL();
     
      await _firestore.collection('users').doc('your_user_id').set({
        'profile_picture': downloadURL,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile picture uploaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload profile picture: $e')),
      );
    }
  }

Future<void> _pickLocation() async {
    final currentPosition = await LocationService.getCurrentPosition();
   
    setState(() {
      _currentPosition = currentPosition;
    
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
     
      return Future.error('Layanan lokasi dinonaktifkan.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Izin lokasi ditolak, tidak dapat melanjutkan
        return Future.error('Izin lokasi ditolak.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Izin lokasi ditolak selamanya.');
    }
    try {
      _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print('Lokasi gweh saat ini: $_currentPosition');
      _getAddressFromLatLng(_currentPosition!);
    } catch (e) {
      print('Gagal mendapatkan apa ya: $e');
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
        });
        print('Alamat kita cik: $_currentAddress');
      } else {
        setState(() {
          _currentAddress = 'Gagal dapat alamatnay eh elah.';
        });
        print('Gagal mendapatkan alamat dari koordinat yang ada.');
      }
    } catch (e) {
      setState(() {
        _currentAddress = 'Gagal lagi gagal lagi.';
      });
      print('Gagal mendapatkan alamat: $e');
    }
  }


  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Gallery'),
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    _pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No Data Found'));
          }
          
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return SingleChildScrollView(
            
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:  _image != null ? FileImage(_image!) : null,
              child: _image == null
                  ? Icon(
                      Icons.person,
                      size: 80,
                    )
                  : null,
                  
                  ),
                   SizedBox(height: 0),
           
                  Positioned(
              top: 10,
              bottom: 0,
              right: 10,
              child: InkWell(
                onTap: () {
                  _showPicker(context);
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
              ),
                  ),
                   Center(
                     child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
             border: Border(
                bottom: BorderSide(color: Colors.black, width: 2.0),
              ),
            ),
                       child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 10.0),
                Text(
                  '${userData['name']}',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 30.0,
                ),
              ],
            ),
                     ),
                   ),
                   Center(
                     child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
             border: Border(
                bottom: BorderSide(color: Colors.black, width: 2.0),
              ),
            ),
                       child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween, 
               mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 10.0), 
                Text(
                  '${userData['phoneNumber']}',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(
                  Icons.phone,
                  color: Colors.black,
                  size: 30.0,
                ),
              ],
            ),
                     ),
                   ),
                   Center(
                     child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
             border: Border(
                bottom: BorderSide(color: Colors.black, width: 2.0),
              ),
            ),
                       child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 10.0), 
                Text(
                  '${userData['email']}',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(
                  Icons.mail,
                  color: Colors.black,
                  size: 30.0,
                ),
              ],
            ),
                     ),
                   ),
          
                   Center(
                     child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
             border: Border(
                bottom: BorderSide(color: Colors.black, width: 2.0),
              ),
            ),
                       child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(width: 10.0),
                if(_currentPosition != null)
             
                Expanded(child: Text(_currentAddress)),
                Spacer(),
                IconButton(
            icon: Icon(Icons.map),
            iconSize: 30.0,
            color: Colors.black,
            onPressed: _pickLocation,
             
          ),
              ],
            ),
                     ),
                   ),
                    SizedBox(height: 16),
                isSignedIn
                ? TextButton(onPressed: signOut, child: const Text("Sign Out"))
                : TextButton(onPressed: signIn, child: const Text("Sign In"))
                ],
              ),
            ),
            
          );
          
        },
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: _uploadImage,
        child: Icon(Icons.upload),
      ),
    );
  }
}
  