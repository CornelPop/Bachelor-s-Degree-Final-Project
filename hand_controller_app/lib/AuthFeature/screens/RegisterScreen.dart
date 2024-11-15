import 'package:flutter/material.dart';
import 'package:hand_controller_app/AuthFeature/services/AuthService.dart';

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
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                    height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person),
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
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
                    Container(
                    height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState((){
                                showConfirmPass = !showConfirmPass;
                              });
                            },
                            child: showConfirmPass ? Icon(Icons.disabled_visible_rounded) : Icon(Icons.remove_red_eye_rounded),
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
                    const SizedBox(height: 10),
                    Container(
                    height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          value: _role,
                          decoration: const InputDecoration(
                            labelText: 'Role',
                            prefixIcon: Icon(Icons.category),
                            border: InputBorder.none,
                          ),
                          items: ['Patient', 'Doctor'].map((String role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _role = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a role';
                            }
                            return null;
                          },
                          icon: const SizedBox.shrink(), // Make the dropdown arrow icon disappear
                          isExpanded: true,
                          dropdownColor: Colors.blue[100],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
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
                          primary: Colors.blue[500],
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
                    const SizedBox(height: 10),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an accouont?",
                            style: TextStyle(
                                color: Colors.black
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
        ),
      );
  }
}
