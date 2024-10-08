//
//
//
// import 'package:flutter/material.dart';
// import 'package:sachetana_firebase/screens/home.dart';
// import 'package:sachetana_firebase/screens/loginSignup/Services/authentication.dart';
// import 'package:sachetana_firebase/screens/loginSignup/login_modal.dart';
// import 'package:sachetana_firebase/screens/new_homepage.dart';
// import 'package:sachetana_firebase/widgets/snack_bar.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
//
// class SignUpModal extends StatefulWidget {
//   const SignUpModal({super.key});
//
//   @override
//   _SignUpModalState createState() => _SignUpModalState();
// }
//
// class _SignUpModalState extends State<SignUpModal> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//
//   final _formKey = GlobalKey<FormState>();
//   bool isLoading = false;
//   bool isStudent = false;
//
//   void signUpUser() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         isLoading = true;
//       });
//
//       try {
//         String res = await AuthServices().signUpUser(
//           name: nameController.text,
//           phoneNum: phoneController.text,
//           email: emailController.text,
//           password: passwordController.text,
//         );
//
//         if (res == "Successfully Signed In") {
//           // Save login status to SharedPreferences
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.setBool('isLoggedIn', true);
//
//           // Navigate to HomeScreen with isLoggedIn set to true
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => HomePage(isLoggedIn: true)),
//           );
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//           // Show the error message
//           showSnackBar(context, res);
//         }
//       } catch (e) {
//         setState(() {
//           isLoading = false;
//         });
//         // Show the error message
//         showSnackBar(context, e.toString());
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Container(
//         padding: const EdgeInsets.all(35.0),
//         height: MediaQuery.of(context).size.height * 0.9,
//         width: MediaQuery.of(context).size.width,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Center(
//                 child: Image.asset(
//                   'assets/images/selfie.png', // Replace with your image path
//                   height: 150,
//                   width: 150,
//                 ),
//               ),
//               const Text(
//                 "Sign Up",
//                 style: TextStyle(fontSize: 60, fontFamily: 'DMSerifDisplay'),
//               ),
//               const SizedBox(height: 10),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context); // Close this modal first
//                   showModalBottomSheet(
//                     context: context,
//                     isScrollControlled: true,
//                     builder: (context) => LoginModal(),
//                   );
//                 },
//                 child: const Text(
//                   "Registered User? Log In",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     _buildTextField(nameController, 'Name', 'Please enter your name'),
//                     const SizedBox(height: 10),
//                     _buildTextField(phoneController, 'Phone Number', 'Please enter your phone number'),
//                     const SizedBox(height: 10),
//                     _buildEmailField(),
//                     const SizedBox(height: 10),
//                     _buildPasswordField(),
//                     Row(
//                       children: [
//                         Checkbox(
//                           value: isStudent,
//                           onChanged: (value) {
//                             setState(() {
//                               isStudent = value ?? false;
//                             });
//                           },
//                         ),
//                         const Text("Are you a student?", style: TextStyle(fontFamily:'DMSans', fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: signUpUser,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor : Colors.black,
//                         padding : EdgeInsets.symmetric(horizontal : 60, vertical : 20),
//                         shape : RoundedRectangleBorder(borderRadius : BorderRadius.circular(7)),
//                       ), // Directly call signUpUser function
//                       child:
//                       isLoading ? CircularProgressIndicator(color: Colors.white) : const Text('Continue', style: TextStyle(color: Colors.white, fontFamily:'DMSans', fontWeight: FontWeight.bold)),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String labelText, String validationMessage) {
//     return TextFormField(
//       controller : controller,
//       decoration : InputDecoration(
//         labelText : labelText,
//         labelStyle : const TextStyle(color : Colors.white, fontFamily : 'DMSans'),
//         filled : true,
//         fillColor : Colors.indigoAccent.shade200,
//         border : InputBorder.none,
//       ),
//       style : const TextStyle(color : Colors.white),
//       validator : (value) {
//         if (value == null || value.isEmpty) {
//           return validationMessage;
//         }
//         return null;
//       },
//     );
//   }
//
//   Widget _buildEmailField() {
//     return TextFormField(
//       controller : emailController,
//       decoration :
//       InputDecoration(labelText:'Email ID', labelStyle : const TextStyle(color : Colors.white , fontFamily : 'DMSans'), filled : true , fillColor : Colors.indigoAccent.shade200 , border : InputBorder.none,),
//       style : const TextStyle(color : Colors.white),
//       validator : (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter your email';
//         } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//           return 'Please enter a valid email address';
//         }
//         return null;
//       },
//     );
//   }
//
//   Widget _buildPasswordField() {
//     return TextFormField(
//       controller : passwordController,
//       decoration :
//       InputDecoration(labelText:'Password', labelStyle : const TextStyle(color : Colors.white , fontFamily:'DMSans'), filled:true , fillColor : Colors.indigoAccent.shade200 , border : InputBorder.none,),
//       obscureText:true,
//       style : const TextStyle(color : Colors.white),
//       validator :(value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter your password';
//         } else if (value.length <6 || !RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9]).+$').hasMatch(value)) {
//           return 'Password must be at least6 characters long and contain letters and numbers';
//         }
//         return null;
//       },
//     );
//   }
// }
//
//






import 'package:flutter/material.dart';
import 'package:sachetana_firebase/screens/home.dart';
import 'package:sachetana_firebase/screens/loginSignup/Services/authentication.dart';
import 'package:sachetana_firebase/screens/loginSignup/login_modal.dart';
import 'package:sachetana_firebase/widgets/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpModal extends StatefulWidget {
  const SignUpModal({Key? key}) : super(key: key);

  @override
  _SignUpModalState createState() => _SignUpModalState();
}

class _SignUpModalState extends State<SignUpModal> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isStudent = false;
  bool showLoginPrompt = false;

  void signUpUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        String res = await AuthServices().signUpUser(
          name: nameController.text,
          phoneNum: phoneController.text,
          email: emailController.text,
          password: passwordController.text,
        );

        if (res == "Successfully Signed In") {
          // Save login status to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);

          setState(() {
            isLoading = false;
            showLoginPrompt = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          // Show the error message
          showSnackBar(context, res);
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        // Show the error message
        showSnackBar(context, e.toString());
      }
    }
  }

  void proceedToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginModal()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(35.0),
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/selfie.png',
                  height: 150,
                  width: 150,
                ),
              ),
              const Text(
                "Sign Up",
                style: TextStyle(fontSize: 60, fontFamily: 'DMSerifDisplay'),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => LoginModal(),
                  );
                },
                child: const Text(
                  "Registered User? Log In",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(nameController, 'Name', 'Please enter your name'),
                    const SizedBox(height: 10),
                    _buildTextField(phoneController, 'Phone Number', 'Please enter your phone number'),
                    const SizedBox(height: 10),
                    _buildEmailField(),
                    const SizedBox(height: 10),
                    _buildPasswordField(),
                    Row(
                      children: [
                        Checkbox(
                          value: isStudent,
                          onChanged: (value) {
                            setState(() {
                              isStudent = value ?? false;
                            });
                          },
                        ),
                        const Text("Are you a student?", style: TextStyle(fontFamily:'DMSans', fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: signUpUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : const Text('Continue', style: TextStyle(color: Colors.white, fontFamily:'DMSans', fontWeight: FontWeight.bold)),
                    ),
                    if (showLoginPrompt) ...[
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: proceedToLogin,
                        child: const Text(
                          "Registration successful. Tap here to proceed to Login",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, String validationMessage) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white, fontFamily: 'DMSans'),
        filled: true,
        fillColor: Colors.indigoAccent.shade200,
        border: InputBorder.none,
      ),
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        labelText: 'Email ID',
        labelStyle: const TextStyle(color: Colors.white, fontFamily: 'DMSans'),
        filled: true,
        fillColor: Colors.indigoAccent.shade200,
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
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(color: Colors.white, fontFamily: 'DMSans'),
        filled: true,
        fillColor: Colors.indigoAccent.shade200,
        border: InputBorder.none,
      ),
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        } else if (value.length < 6 || !RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9]).+$').hasMatch(value)) {
          return 'Password must be at least 6 characters long and contain letters and numbers';
        }
        return null;
      },
    );
  }
}