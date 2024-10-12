import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:friendsphere/resources/auth_methods.dart';
import 'package:friendsphere/responsive/responsive_layout.dart';
import 'package:friendsphere/screens/login_screen.dart';
import 'package:friendsphere/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:friendsphere/responsive/mobile_screen_layout.dart';
import 'package:friendsphere/responsive/web_screen_layout.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.camera);
    setState(() {
      _image = im;
    });
  }

  void singUp() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().SignUpUser(
        email: _emailController.text,
        name: _nameController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
                webScreenLayout: webScreenLayout(),
                mobileScreenLayout: mobileScreenLayout()),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  Future<void> _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Image Source'),
        children: <Widget>[
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Take a photo'),
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              Uint8List? im = await pickImage(ImageSource.camera);
              if (im != null) {
                setState(() {
                  _image = im;
                });
              }
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Choose from gallery'),
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              Uint8List? im = await pickImage(ImageSource.gallery);
              if (im != null) {
                setState(() {
                  _image = im;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Signup')),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () => _selectImage(context),
                  child: CircleAvatar(
                    backgroundColor: Colors.teal,
                    radius: 60,
                    backgroundImage: _image != null
                        ? MemoryImage(_image!)
                        : const NetworkImage('https://i.stack.imgur.com/l60Hf.png'),
                    child: _image == null
                        ? const Icon(Icons.account_circle, size: 60)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(labelText: 'Bio'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Bio is needed";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(

                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        singUp();
                      }
                    },
                    child: _isLoading ? const CircularProgressIndicator() :  const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("Already have an account ?"),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: ()=>Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>const LoginScreen())
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontWeight: FontWeight.bold),
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
