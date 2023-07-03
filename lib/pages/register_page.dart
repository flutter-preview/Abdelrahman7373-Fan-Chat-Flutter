import 'package:fan_chat/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  bool obscurePassword = true;

  void signUp () async {
    if(passwordController.text != confirmPasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red,),);
      return;
    }

    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password should be at least 6 characters long!', style: TextStyle(color: Colors.white)),backgroundColor: Colors.red,),);
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailAndPassword(emailController.text, passwordController.text, nameController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),),);
    }
  }

  void togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 25,),

                Image.asset('assets/Logo.png',width: 80,height: 80,),

                const SizedBox(height: 10,),

                const Text("Let's Create a New Account",style: TextStyle(fontSize: 16,),),

                const SizedBox(height: 30,),

                MyTextField(controller: nameController, hintText: 'Name', obscureText: false),
                const SizedBox(height: 10,),
                MyTextField(controller: emailController, hintText: 'Email', obscureText: false),
                IconButton(onPressed: togglePasswordVisibility, icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),),
                MyTextField(controller: passwordController, hintText: 'Password', obscureText: obscurePassword,),
                const SizedBox(height: 10,),
                MyTextField(controller: confirmPasswordController, hintText: 'Confirm Password', obscureText: obscurePassword,),

                const SizedBox(height: 25,),

                MyButton(onTap: signUp, text: 'Register!'),

                const SizedBox(height: 25,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'), const SizedBox(width: 4,), 
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Log In Now!', style: TextStyle(fontWeight: FontWeight.bold,),)
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }
}