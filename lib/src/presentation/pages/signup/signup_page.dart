import 'package:chatapp_ui/src/presentation/blocs/auth/auth_cubit.dart';
import 'package:chatapp_ui/src/presentation/common/ui_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _usernameController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _usernameController = TextEditingController();
    _fullNameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "SignUp",
                    style: TextStyle(
                      color: UIColors.surface20,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      filled: true,
                      hintText: "Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if ((value ?? "").isEmpty) {
                        return "Username cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      filled: true,
                      hintText: "Full Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if ((value ?? "").isEmpty) {
                        return "Full Name cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      filled: true,
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if ((value ?? "").isEmpty) {
                        return "Password cannot be empty";
                      }
                      return null;
                    },
                  ),
                  if (state is AuthSignUpErrorState) const SizedBox(height: 16),
                  if (state is AuthSignUpErrorState)
                    Text(
                      state.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: state is AuthSignUpLoadingState
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<AuthCubit>().register(
                                    username: _usernameController.text,
                                    fullName: _fullNameController.text,
                                    password: _passwordController.text,
                                  );
                            }
                          },
                    child: const Text("SignUp"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
