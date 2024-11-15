// lib/AuthFeature/screens/sign_in_screen.dart

import 'package:flutter/material.dart';
import 'package:hand_controller_app/AuthFeature/screens/RegisterScreen.dart';
import 'package:hand_controller_app/AuthFeature/services/SharedPrefService.dart';
import 'package:hand_controller_app/TrainingProgramsFeature/screens/TrainingProgramScreen.dart';

import '../services/AuthService.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final AuthService _authService = AuthService();
  final SharedPrefsService sharedPrefsService = SharedPrefsService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _message;
  bool showPass = false;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blue[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          centerTitle: true,
          title: const Text('HandHero'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50,),
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Enter your credentials to login',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 70,),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.mail),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState((){
                                showPass = !showPass;
                              });
                            },
                            child: showPass ? Icon(Icons.disabled_visible_rounded) : Icon(Icons.remove_red_eye_rounded),
                          ),
                          border: InputBorder.none,
                      ),
                      obscureText: !showPass,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Snackbar forgot password!'),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.blue
                        ),),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value ?? false;
                            });
                          },
                        ),
                        const Text('Remember me',),
                      ],
                    )

                  ),
                  //const SizedBox(height: 20),
                  Container(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final message = await _authService.signIn(
                          _emailController.text,
                          _passwordController.text,
                        );
                        setState(() {
                          _message = message;
                        });
                        if (message != null && !message.startsWith('E')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TrainingProgramScreen()),
                          );

                          print(isChecked);
                          sharedPrefsService.storeRememberMe(isChecked);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[500],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Facebook sign in!'),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all()
                            ),
                            child: Row(
                              children: [
                                Image.asset("assets/facebook_logo.png",
                                  fit: BoxFit.cover,
                                  width: 25,
                                  height: 25,
                                ),
                                SizedBox(width: 10,),
                                const Text(
                                  'Sign in',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                  ),),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () async {
                            if ( await _authService.signInWithGoogle() != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TrainingProgramScreen()),
                              );
                            };
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all()
                            ),
                            child: Row(
                              children: [
                                Image.asset("assets/google_logo.png",
                                  fit: BoxFit.cover,
                                  width: 25,
                                  height: 25,
                                ),
                                SizedBox(width: 10,),
                                const Text(
                                  'Sign in',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                  ),),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                              color: Colors.black
                          ),
                        ),
                        SizedBox(width: 10,),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterScreen()),
                            );
                          },
                          child: const Text(
                            'Sign up!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue
                            ),),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_message != null)
                    Text(
                      _message!,
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
