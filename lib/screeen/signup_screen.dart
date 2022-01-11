import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instergram_flutter/resources/auth_method.dart';
import 'package:instergram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instergram_flutter/responsive/responsive_screen.dart';
import 'package:instergram_flutter/responsive/web_screen_layout.dart';
import 'package:instergram_flutter/screeen/login_screen.dart';
import 'package:instergram_flutter/utilities/color.dart';
import 'package:instergram_flutter/utilities/utils.dart';
import 'package:instergram_flutter/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

late TextEditingController _userController;
late TextEditingController _emailController;
late TextEditingController _passController;
late TextEditingController _bioController;
Uint8List? _image;
bool _isLoading = false;

class _SignupScreenState extends State<SignupScreen> {
  @override
  void initState() {
    super.initState();
    _userController = TextEditingController();
    _emailController = TextEditingController();
    _passController = TextEditingController();
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _userController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _bioController.dispose();
  }

  navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void selectImage() async {
    Uint8List img = await pickerImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  signUp() async {
    setState(() {
      _isLoading = true;
    });
    var res = await AuthMethod().signUpUser(
      email: _emailController.text,
      password: _passController.text,
      username: _userController.text,
      bio: _bioController.text,
      file: _image!,
    );
    if (kDebugMode) {
      print(res);
    }
    if (res != 'success') {
      setState(() {
        _isLoading = false;
      });
      showSnckBar(res, context);
    } else if (res == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),

              //logo
              SvgPicture.asset(
                "assets/ic_instagram.svg",
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 24,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"),
                        ),
                  Positioned(
                    child: IconButton(
                      icon: const Icon(Icons.add_a_photo),
                      onPressed: selectImage,
                    ),
                    bottom: -1,
                    right: 10,
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              //email form
              TextFieldInput(
                textEditingController: _userController,
                hintText: "Enter Your Username",
                textInputType: TextInputType.name,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                textEditingController: _emailController,
                hintText: "Enter Your Email",
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 24,
              ),
              //Password Form
              TextFieldInput(
                textEditingController: _passController,
                hintText: "Enter Your Password",
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                textEditingController: _bioController,
                hintText: "Enter Your Bio",
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: signUp,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const Text(
                          "Sign Up",
                          textAlign: TextAlign.center,
                        ),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text("Already have an account?"),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      child: const Text(
                        "Login.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
