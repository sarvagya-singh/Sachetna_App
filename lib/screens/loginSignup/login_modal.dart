// import 'package:flutter/material.dart';
// import 'package:sachetana_firebase/screens/home.dart';
// import 'package:sachetana_firebase/screens/loginSignup/signup_screen.dart';
// import 'package:sachetana_firebase/screens/new_homepage.dart';
// import 'Services/authentication.dart'; // Import the AuthServices
//
// class LoginModal extends StatefulWidget {
//   const LoginModal({super.key});
//
//   @override
//   _LoginModalState createState() => _LoginModalState();
// }
//
// class _LoginModalState extends State<LoginModal> {
//   final _formKey = GlobalKey<FormState>();
//   String phoneNumber = '';
//   String email = '';
//   String password = '';
//   String otp = '';
//   bool isEmailMode = true; // Toggle between Email and Phone mode
//   bool isLoading = false;
//
//   final AuthServices _authServices = AuthServices(); // AuthServices instance
//
//   // Function to handle login
//   Future<void> _loginUser() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         isLoading = true;
//       });
//
//       String res;
//       if (isEmailMode) {
//         // Login with Email and Password
//         res = await _authServices.loginUser(email: email, password: password);
//       } else {
//         // Login via Phone and OTP
//         if (otp.isEmpty) {
//           // Request OTP if not already sent
//           res = await _authServices.requestOTP(phoneNumber: phoneNumber);
//         } else {
//           // Verify OTP if already sent
//           res = await _authServices.verifyOTP(otp: otp);
//         }
//       }
//
//       setState(() {
//         isLoading = false;
//       });
//
//       if (res == "Successfully Logged In" || res == "Successfully Logged In via Phone") {
//         // Navigate to HomeScreen on successful login
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage(isLoggedIn: true)),
//         );
//       } else {
//         // Show error message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(res)),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           return Container(
//             padding: const EdgeInsets.all(35.0),
//             height: MediaQuery.of(context).size.height * 0.8,
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
//             ),
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Image and Title
//                     Center(
//                       child: Image.asset(
//                         'assets/images/selfie.png',
//                         height: 150,
//                         width: 150,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       "Log In",
//                       style: TextStyle(fontSize: 60, fontFamily: 'DMSerifDisplay'),
//                     ),
//                     const SizedBox(height: 10),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context); // Close login modal
//                         showModalBottomSheet(
//                           context: context,
//                           isScrollControlled: true,
//                           builder: (context) => SignUpModal(), // Open SignUp Modal
//                         );
//                       },
//                       child: const Text(
//                         "New User? Sign Up",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//
//                     // Toggle Email/Phone mode
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               isEmailMode = true;
//                             });
//                           },
//                           child: const Text("Email"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: isEmailMode ? Colors.green[200] : Colors.white,
//                             foregroundColor: Colors.black,
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                           ),
//                         ),
//                         const SizedBox(width: 20),
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               isEmailMode = false;
//                             });
//                           },
//                           child: const Text("Phone"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: !isEmailMode ? Colors.green[200] : Colors.white,
//                             foregroundColor: Colors.black,
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 30),
//
//                     // Input form based on selected mode (Email or Phone)
//                     Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           if (isEmailMode) ...[
//                             // Email
//                             TextFormField(
//                               decoration: const InputDecoration(
//                                 labelText: 'Email ID',
//                                 labelStyle: TextStyle(color: Colors.white),
//                                 filled: true,
//                                 fillColor: Colors.indigo,
//                                 border: InputBorder.none,
//                               ),
//                               style: const TextStyle(color: Colors.white),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your email';
//                                 } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                                   return 'Please enter a valid email address';
//                                 }
//                                 return null;
//                               },
//                               onChanged: (value) {
//                                 setState(() {
//                                   email = value;
//                                 });
//                               },
//                             ),
//                             const SizedBox(height: 10),
//                             // Password
//                             TextFormField(
//                               decoration: const InputDecoration(
//                                 labelText: 'Password',
//                                 labelStyle: TextStyle(color: Colors.white),
//                                 filled: true,
//                                 fillColor: Colors.indigo,
//                                 border: InputBorder.none,
//                               ),
//                               obscureText: true,
//                               style: const TextStyle(color: Colors.white),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your password';
//                                 } else if (value.length < 6 ||
//                                     !RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9]).+$').hasMatch(value)) {
//                                   return 'Password must be at least 6 characters long and contain letters and numbers';
//                                 }
//                                 return null;
//                               },
//                               onChanged: (value) {
//                                 setState(() {
//                                   password = value;
//                                 });
//                               },
//                             ),
//                           ] else ...[
//                             // Phone Number
//                             TextFormField(
//                               decoration: const InputDecoration(
//                                 labelText: 'Phone Number',
//                                 labelStyle: TextStyle(color: Colors.white),
//                                 filled: true,
//                                 fillColor: Colors.indigo,
//                                 border: InputBorder.none,
//                               ),
//                               style: const TextStyle(color: Colors.white),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your phone number';
//                                 } else if (!RegExp(r'^\+?\d{10,15}$').hasMatch(value)) {
//                                   return 'Please enter a valid phone number';
//                                 }
//                                 return null;
//                               },
//                               onChanged: (value) {
//                                 setState(() {
//                                   phoneNumber = value;
//                                 });
//                               },
//                             ),
//                             const SizedBox(height: 10),
//                              TextFormField(
//                                 decoration:
//                                 const InputDecoration(
//                                   labelText:
//                                   'OTP',
//                                   labelStyle:
//                                   TextStyle(color:
//                                   Colors.white),
//                                   filled:
//                                   true,
//                                   fillColor:
//                                   Colors.indigo,
//                                   border:
//                                   InputBorder.none,
//                                 ),
//                                 style:
//                                 const TextStyle(color:
//                                 Colors.white),
//                                 onChanged:
//                                     (value) {
//                                   setState(() {
//                                     otp =
//                                         value;
//                                   });
//                                 },
//                                 validator:
//                                     (value) {
//                                   if (value == null ||
//                                       value.isEmpty) {
//                                     return 'Please enter the OTP';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                           ],
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 30),
//
//                     // Continue Button
//                     ElevatedButton(
//                       onPressed: isLoading ? null : _loginUser,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black,
//                         padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(7),
//                         ),
//                       ), // Handle login
//                       child: isLoading
//                           ? CircularProgressIndicator(color: Colors.white)
//                           : const Text(
//                         'Continue',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontFamily: 'DMSans',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
//





import 'package:flutter/material.dart';
import 'package:sachetana_firebase/screens/home.dart';
import 'package:sachetana_firebase/screens/loginSignup/signup_screen.dart';
import 'package:sachetana_firebase/screens/new_homepage.dart';
import 'Services/authentication.dart'; // Import the AuthServices

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
  _LoginModalState createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final _formKey = GlobalKey<FormState>();
  String phoneNumber = '';
  String email = '';
  String password = '';
  String otp = '';
  bool isEmailMode = true; // Toggle between Email and Phone mode
  bool isLoading = false;

  final AuthServices _authServices = AuthServices(); // AuthServices instance

  // Function to handle login
  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String res;
      if (isEmailMode) {
        // Login with Email and Password
        res = await _authServices.loginUser(email: email, password: password);
      } else {
        // Login via Phone and OTP
        if (otp.isEmpty) {
          // Request OTP if not already sent
          res = await _authServices.requestOTP(phoneNumber: phoneNumber);
        } else {
          // Verify OTP if already sent
          res = await _authServices.verifyOTP(otp: otp);
        }
      }

      setState(() {
        isLoading = false;
      });

      if (res == "Successfully Logged In" || res == "Successfully Logged In via Phone") {
        // Navigate to HomeScreen on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(isLoggedIn: true)),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(35.0),
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image and Title
                    Center(
                      child: Image.asset(
                        'assets/images/selfie.png',
                        height: 150,
                        width: 150,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Log In",
                      style: TextStyle(fontSize: 60, fontFamily: 'DMSerifDisplay'),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Close login modal
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => SignUpModal(), // Open SignUp Modal
                        );
                      },
                      child: const Text(
                        "New User? Sign Up",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Toggle Email/Phone mode
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isEmailMode = true;
                            });
                          },
                          child: const Text("Email"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isEmailMode ? Colors.green[200] : Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isEmailMode = false;
                            });
                          },
                          child: const Text("Phone"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !isEmailMode ? Colors.green[200] : Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Input form based on selected mode (Email or Phone)
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (isEmailMode) ...[
                            // Email
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email ID',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: Colors.indigo,
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            // Password
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: Colors.indigo,
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                } else if (value.length < 6 ||
                                    !RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9]).+$').hasMatch(value)) {
                                  return 'Password must be at least 6 characters long and contain letters and numbers';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                            ),
                          ] else ...[
                            // Phone Number
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: Colors.indigo,
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                } else if (!RegExp(r'^\+?\d{10,15}$').hasMatch(value)) {
                                  return 'Please enter a valid phone number';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  phoneNumber = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration:
                              const InputDecoration(
                                labelText:
                                'OTP',
                                labelStyle:
                                TextStyle(color:
                                Colors.white),
                                filled:
                                true,
                                fillColor:
                                Colors.indigo,
                                border:
                                InputBorder.none,
                              ),
                              style:
                              const TextStyle(color:
                              Colors.white),
                              onChanged:
                                  (value) {
                                setState(() {
                                  otp =
                                      value;
                                });
                              },
                              validator:
                                  (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return 'Please enter the OTP';
                                }
                                return null;
                              },
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Continue Button
                    ElevatedButton(
                      onPressed: isLoading ? null : _loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ), // Handle login
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


