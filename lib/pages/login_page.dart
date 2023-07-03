import 'package:fan_chat/components/my_button.dart';
import 'package:fan_chat/components/my_text_field.dart';
import 'package:fan_chat/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPagetState();
}

class _LoginPagetState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  Future<void> logIn () async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailAndPassword(emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Email Or Password!', style: TextStyle(color: Colors.white)),backgroundColor: Colors.red,),);
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
                const SizedBox(height: 50,),

                Image.asset('assets/Logo.png',width: 80,height: 80,),

                const SizedBox(height: 25,),

                const Text('SIGN IN NOW!',style: TextStyle(fontSize: 16,),),

                const SizedBox(height: 30,),

                MyTextField(controller: emailController, hintText: 'Email', obscureText: false),
                IconButton(onPressed: togglePasswordVisibility, icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),),
                MyTextField(controller: passwordController, hintText: 'Password', obscureText: obscurePassword,),

                const SizedBox(height: 25,),

                MyButton(onTap: logIn, text: 'Log In!'),

                const SizedBox(height: 25,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('New To Fan Chat?'), const SizedBox(width: 4,), 
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Register Now!', style: TextStyle(fontWeight: FontWeight.bold,),),
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