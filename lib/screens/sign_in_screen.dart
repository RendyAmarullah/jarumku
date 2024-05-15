import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_jarum/main.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
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
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: main,
                  child: const Text('Sign In'),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero))),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {},
                    child: const Text('Belum punya akun? Daftar di sini.')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
