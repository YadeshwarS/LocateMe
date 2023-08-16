import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'package:locatesret/FacultyPage.dart';
import 'package:locatesret/studentpage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key});

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  String? userType; // Nullable string to track the selected user type
  String _username = '';

  void handleRadioValueChange(String? value) {
    setState(() {
      userType = value;
    });
  }

  void handleSignUp() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passController.text)
        .then((value) {
      print("Created New Account");
      if (userType == 'student') {
        if (_formfield.currentState!.validate()) {
          print('Student Signup Successful');
          Fluttertoast.showToast(
            msg: "Student Signup Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudentDashboardPage()),
          );
        }
      } else if (userType == 'faculty') {
        if (_formfield.currentState!.validate()) {
          print('Faculty Signup Successful');
          Fluttertoast.showToast(
            msg: "Faculty Signup Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FacultyPage()),
          );
        }
      }
    }).onError((error, stackTrace) {
      print("Error ${error.toString()}");
    });
  }

  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  bool passtoggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("SignUp Page"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Form(
            key: _formfield,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    if (value.trim().length < 4) {
                      return 'Username must be at least 4 characters in length';
                    }
                    // Return null if the entered username is valid
                    return null;
                  },
                  onChanged: (value) => _username = value,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value!);

                    if (value.isEmpty) {
                      return "Enter Email";
                    } else if (!emailValid) {
                      return "Enter Valid Email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  onChanged: (value) {
                    _formfield.currentState?.validate();
                  },
                  decoration: const InputDecoration(
                    labelText: "Mobile Number",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Mobile Number";
                    } else if (value.length != 10) {
                      return "Mobile Number should be 10 digits long";
                    } else if (!RegExp(r'^[789]\d{9}$').hasMatch(value)) {
                      return "Please enter a valid mobile number";
                    }
                    return null; // Return null if the mobile number is valid
                  },
                  maxLength: 10, // Limit the input to 10 characters
                ),
                Column(
                  children: [
                    ListTile(
                      title: const Text('Student'),
                      leading: Radio(
                        value: 'student',
                        groupValue: userType,
                        onChanged: handleRadioValueChange,
                      ),
                    ),
                    ListTile(
                      title: const Text('Faculty'),
                      leading: Radio(
                        value: 'faculty',
                        groupValue: userType,
                        onChanged: handleRadioValueChange,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: passController,
                  obscureText: passtoggle,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          passtoggle = !passtoggle;
                        });
                      },
                      child: Icon(
                          passtoggle ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Password";
                    } else if (passController.text.length < 6) {
                      return "Password Length Should be more than 6 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 60),
                InkWell(
                  onTap: handleSignUp,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const loginpage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
