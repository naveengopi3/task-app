import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/bloc/auth/auth_bloc.dart';
import 'package:task_app/screens/auth/login_screen.dart';
import 'package:task_app/utils/app_colors.dart';
import 'package:task_app/utils/auth_validators.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _validators = AuthValidators();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Account created successfully. You can now log in.",
                  ),
                  backgroundColor: AppColors.green,
                ),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sign up failed. Please try again.'),
                  backgroundColor: AppColors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: SizedBox(
                height: screenHeight,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      colors: [AppColors.purple, AppColors.lightPurple],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sign up",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "Welcome! Create your new account now.",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Form(
                              autovalidateMode: AutovalidateMode.onUnfocus,
                              key: _formKey,
                              child: Column(
                                children: [
                                  SizedBox(height: 80),
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                            150,
                                            100,
                                            220,
                                            0.4,
                                          ),
                                          blurRadius: 20,
                                          offset: Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      spacing: 15,
                                      children: [
                                        TextFormField(
                                          decoration: InputDecoration(
                                            hintText: "Name",
                                            hintStyle: TextStyle(
                                              color: AppColors.grey,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.grey,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.purple,
                                              ),
                                            ),
                                          ),
                                          controller: _nameController,
                                          validator: _validators.validateName,
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            hintText: "Email",
                                            hintStyle: TextStyle(
                                              color: AppColors.grey,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.grey,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.purple,
                                              ),
                                            ),
                                          ),
                                          controller: _emailController,
                                          validator: _validators.validateEmail,
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            hintText: "Password",
                                            hintStyle: TextStyle(
                                              color: AppColors.grey,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.grey,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.purple,
                                              ),
                                            ),
                                          ),
                                          obscureText: true,
                                          controller: _passwordController,
                                          validator:
                                              _validators.validatePassword,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.04),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: AppColors.purple,
                                    ),
                                    width: screenWidth * 0.5,
                                    height: 50,
                                    child: TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<AuthBloc>().add(
                                            SignUpEvent(
                                              name: _nameController.text.trim(),
                                              email:
                                                  _emailController.text.trim(),
                                              password:
                                                  _passwordController.text
                                                      .trim(),
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        "Sign up",
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.04),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Already have an account?"),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => LoginScreen(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                            color: AppColors.purple,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
      ),
    );
  }
}
