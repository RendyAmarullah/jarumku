import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
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
                    backgroundImage: NetworkImage('https://ih0.redbubble.net/image.4771882718.3934/raf,360x360,075,t,fafafa:ca443f4786.jpg'), // Ganti URL dengan URL gambar profil pengguna jika tersedia
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
               mainAxisAlignment: MainAxisAlignment.spaceBetween, // Menempatkan ikon di ujung kanan
               mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 10.0), // Spasi antara ikon dan teks
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
                  
                  Text
                  ('Phone Number: ${userData['phoneNumber']}'
                    ,style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  Text(
                    'Email: ${userData['email']}',
                   style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                   ),
                  Text(
                    'Password: ${userData['password']}',
                     style: TextStyle(fontSize: 24)
                     )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}