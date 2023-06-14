import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text contorollers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  // Role selection
  String? _selectedRole;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    if (passwordConfirmed()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      String role = _selectedRole ?? '';

      // Create user
      try {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        final user = userCredential.user;
        
       
        if (role.isNotEmpty) {
          // Add user details with role to Firestore
          await addUserDetails(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            email,
            role,
            user!.uid,
          );
          // User registration successful, navigate to login page
          widget.showLoginPage();
        } else {
          print('user has no role.');
        }
      } on FirebaseAuthException catch (e) {
       
        print('Failed to create user: ${e.message}');
        
      }
    }
  }

  Future<void> addUserDetails(String firstName, String lastName, String email,
      String role, String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'role': role,
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 56, 82),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              //Image.asset(
              //'assets/images/logo.png',
              //  width: 180,
              //height: 200,
              //),
              //başlık
              const Text(
                "TAKE ATTENDANCE WITH FACE ID",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "Welcome! Register now",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),

              //firstName
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'First Name',
                    fillColor: const Color.fromARGB(255, 244, 247, 248),
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              //last Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Last Name',
                    fillColor: const Color.fromARGB(255, 244, 247, 248),
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              //email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Email',
                    fillColor: const Color.fromARGB(255, 244, 247, 248),
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              //password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Password',
                    fillColor: const Color.fromARGB(255, 244, 247, 248),
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              //confirm password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _confirmpasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Confirm Password',
                    fillColor: const Color.fromARGB(255, 244, 247, 248),
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Role selection radio buttons
                    Row(
                      children: [
                        Radio<String>(
                          value: 'teacher',
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value;
                            });
                          },
                        ),
                        const Text(
                          'Teacher',
                          style: TextStyle(color: Colors.white),
                        ),
                        Radio<String>(
                          value: 'student',
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value;
                            });
                          },
                        ),
                        const Text(
                          'Student',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),

                    //button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: GestureDetector(
                        onTap: signUp,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(57, 209, 213, 238),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    //not a member
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Have An Account ?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: widget.showLoginPage,
                          child: const Text(
                            ' Login',
                            style: TextStyle(
                              color: Color.fromARGB(255, 165, 186, 197),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
