import 'package:flutter/material.dart';
import 'package:hand_controller_app/AuthFeature/screens/RegisterScreen.dart';
import 'package:hand_controller_app/AuthFeature/services/SharedPrefService.dart';
import 'package:hand_controller_app/TrainingProgramsFeature/screens/TrainingProgramScreen.dart';

import '../../GlobalThemeData.dart';
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
      body: signInContentWidget(),
    );
  }

  Widget signInContentWidget() {
    return Container(
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
                      'Welcome Back',
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
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.mail, color: Colors.white),
                          border: InputBorder.none,
                          labelStyle: TextStyle(color: Colors.white),
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
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
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
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                showPass = !showPass;
                              });
                            },
                            child: Icon(
                              showPass ? Icons.visibility : Icons.visibility_off,
                              color: Colors.white,
                            ),
                          ),
                          border: InputBorder.none,
                          labelStyle: TextStyle(color: Colors.white),
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
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
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
                            color: CustomTheme.secondaryColor,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Checkbox(
                            checkColor: CustomTheme.secondaryColor,
                            // activeColor: ,
                            // focusColor: ,
                            // overlayColor: ,
                            fillColor: MaterialStateProperty.resolveWith((states) {
                              return CustomTheme.accentColor2;
                            }),
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value ?? false;
                              });
                            },
                          ),
                          const Text('Remember me', style: TextStyle(color: CustomTheme.secondaryColor),),
                        ],
                      ),
                    ),
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
                            sharedPrefsService.storeRememberMe(isChecked);
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
                          'Login',
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              height: 1,
                              color: CustomTheme.secondaryColor,
                            ),
                          ),
                          const Text(
                            'OR',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomTheme.secondaryColor,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              height: 1,
                              color: CustomTheme.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      height: 50,
                      width: double.infinity,
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
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                      ),
                      padding: const EdgeInsets.all(2), // Padding to display the border
                      child: ElevatedButton(
                        onPressed: () async {
                          if (await _authService.signInWithGoogle() != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TrainingProgramScreen()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: CustomTheme.secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/google_logo.png",
                              fit: BoxFit.cover,
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(width: 10),
                            const Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(color: CustomTheme.secondaryColor),
                          ),
                          SizedBox(width: 10),
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
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                color: CustomTheme.accentColor2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //if (_message != null)
                      // Container(
                      //   alignment: Alignment.center,
                      //   child: Text(
                      //     _message!,
                      //     style: TextStyle(
                      //       color: Colors.red,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 16,
                      //     ),
                      //   ),
                      // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
