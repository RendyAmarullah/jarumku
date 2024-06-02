import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_jarum/main.dart';
import 'package:project_jarum/screens/profile_screen.dart';
import 'package:project_jarum/screens/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final  _emailController = TextEditingController();
  final  _passwordController = TextEditingController();
  final  _userName = TextEditingController();
  final  _fullName = TextEditingController();
  final  _phoneNumber = TextEditingController();
  final  _reEnterPassword = TextEditingController();
  bool _rememberMe = false;
  bool _obscureText = true;

  final key = encrypt.Key.fromLength(32);
  final iv = encrypt.IV.fromLength(16);
  late encrypt.Encrypter encrypter;

  @override
  void initState() {
    super.initState();
    encrypter = encrypt.Encrypter(encrypt.AES(key));
    _loadUserInfo();
  }

  String encryptPassword(String password) {
    final encrypted = encrypter.encrypt(password, iv: iv);
    return encrypted.base64;
  }

  

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('remember_me') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  _saveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('remember_me', _rememberMe);
    if (_rememberMe) {
      prefs.setString('email', _emailController.text);
      prefs.setString('password', _passwordController.text);
    } else {
      prefs.remove('email');
      prefs.remove('password');
    }
  }

  _login() {
    // Implementasikan logika login di sini
    _saveUserInfo();
    // Navigasi ke halaman berikutnya jika login berhasil
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Center(
                  child: Image.asset('images/9.png'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: "Email",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      fillColor: Colors.white,
                      filled: true),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _fullName,
                  decoration: InputDecoration(
                      labelText: "Full Name",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      fillColor: Colors.white,
                      filled: true),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _phoneNumber,
                  decoration: InputDecoration(
                      labelText: "Phone Number",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      fillColor: Colors.white,
                      filled: true),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _userName,
                  decoration: InputDecoration(
                      labelText: "Username",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      fillColor: Colors.white,
                      filled: true),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                      labelText: "Password",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      suffixIcon: IconButton( 
                         icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                      ),
                      fillColor: Colors.white,
                      filled: true),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _reEnterPassword,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                      labelText: "Re-Enter Password",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      suffixIcon: IconButton( 
                         icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                      ),
                      fillColor: Colors.white,
                      filled: true),
                ),
                SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Remember Me'),
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (newValue) {
                        setState(() {
                          _rememberMe = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                      try {
                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  
                  // Simpan data tambahan ke Firestore
                  await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
                    'email': _emailController.text,
                    'phoneNumber' : _phoneNumber.text,
                    'name': _userName.text,
                    'password' : _passwordController.text

                  });

                  Navigator.pushReplacementNamed(context, '/home');
                } catch (e) {
                  print(e);
                }
              },
              child: Text('Sign Up'),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero))),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => MainScreen()),
                      );
                    },
                    child: const Text('Sudah Punya Akun? Login Di sini')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
