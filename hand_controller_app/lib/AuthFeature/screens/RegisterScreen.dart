import 'package:flutter/material.dart';
import 'package:hand_controller_app/AuthFeature/services/AuthService.dart';

import '../../GlobalThemeData.dart';
import 'SignInScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _message;
  String? _role;
  bool showPass = false;
  bool showConfirmPass = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [CustomTheme.accentColor3, CustomTheme.mainColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.transparent, // Make border color transparent to show the gradient
                    ),
                  ),
                  child: Image.asset(
                    "images/logo.png",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Create an account',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: CustomTheme.secondaryColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [CustomTheme.accentColor3, CustomTheme.accentColor2, CustomTheme.accentColor],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),  // Shadow color
                                blurRadius: 20,  // Blur radius
                                offset: Offset(0, 0),  // Offset of the shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.person, color: Colors.white),
                              labelStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [CustomTheme.accentColor3, CustomTheme.accentColor2, CustomTheme.accentColor],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),  // Shadow color
                                blurRadius: 20,  // Blur radius
                                offset: Offset(0, 0),  // Offset of the shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.mail, color: Colors.white),
                              labelStyle: TextStyle(color: Colors.white),
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
                        const SizedBox(height: 10),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [CustomTheme.accentColor3, CustomTheme.accentColor2, CustomTheme.accentColor],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),  // Shadow color
                                blurRadius: 20,  // Blur radius
                                offset: Offset(0, 0),  // Offset of the shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock, color: Colors.white),
                              labelStyle: TextStyle(color: Colors.white),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showPass = !showPass;
                                  });
                                },
                                child: showPass
                                    ? Icon(Icons.disabled_visible_rounded, color: Colors.white)
                                    : Icon(Icons.remove_red_eye_rounded, color: Colors.white),
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
                        const SizedBox(height: 10),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [CustomTheme.accentColor3, CustomTheme.accentColor2, CustomTheme.accentColor],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),  // Shadow color
                                blurRadius: 20,  // Blur radius
                                offset: Offset(0, 0),  // Offset of the shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: Icon(Icons.lock, color: Colors.white),
                              labelStyle: TextStyle(color: Colors.white),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showConfirmPass = !showConfirmPass;
                                  });
                                },
                                child: showConfirmPass
                                    ? Icon(Icons.disabled_visible_rounded, color: Colors.white)
                                    : Icon(Icons.remove_red_eye_rounded, color: Colors.white),
                              ),
                              border: InputBorder.none,
                            ),
                            obscureText: !showConfirmPass,
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Choose you title from the options below:",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [CustomTheme.accentColor3, CustomTheme.accentColor2, CustomTheme.accentColor],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),  // Shadow color
                                blurRadius: 20,  // Blur radius
                                offset: Offset(0, 0),  // Offset of the shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Icon(Icons.badge, color: Colors.white),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 36.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _role = 'Patient';
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: _role == 'Patient' ? CustomTheme.accentColor : Colors.transparent,
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(
                                              color: _role == 'Patient' ? Colors.white : Colors.transparent,
                                            ),
                                          ),
                                          child: Text(
                                            'Patient',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _role = 'Doctor';
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: _role == 'Doctor' ? CustomTheme.accentColor3 : Colors.transparent,
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(
                                              color: _role == 'Doctor' ? Colors.white : Colors.transparent,
                                            ),
                                          ),
                                          child: Text(
                                            'Doctor',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [CustomTheme.accentColor3, CustomTheme.accentColor2, CustomTheme.accentColor],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),  // Shadow color
                                blurRadius: 20,  // Blur radius
                                offset: Offset(0, 0),  // Offset of the shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final message = await _authService.register(
                                _emailController.text,
                                _passwordController.text,
                                _nameController.text,
                                _role!,
                              );
                              setState(() {
                                _message = message;
                              });
                              if (message != null && !message.startsWith('E')) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignInScreen()),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                              SizedBox(width: 10,),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Sign in!',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    color: CustomTheme.accentColor2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // const SizedBox(height: 20),
                        // if (_message != null)
                        //   Text(
                        //     _message!,
                        //     style: const TextStyle(color: Colors.red),
                        //   ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
      );
  }
}
