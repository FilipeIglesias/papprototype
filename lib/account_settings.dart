import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papprototype/ui/models/input_field.dart';
import 'package:papprototype/ui/widgets/input_field.dart';

class ChangeEmailOrPasswordPage extends StatefulWidget {
  final FirebaseAuth auth;

  const ChangeEmailOrPasswordPage({Key? key, required this.auth})
      : super(key: key);

  @override
  _ChangeEmailOrPasswordPageState createState() =>
      _ChangeEmailOrPasswordPageState();
}

class _ChangeEmailOrPasswordPageState extends State<ChangeEmailOrPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _newEmail = '';
  String _newPassword = '';

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change email or password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change email',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              InputField(
                'New email',
                Icons.email,
                _emailController,
                obscureText: false,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  _newEmail = _emailController.text.trim();
                  if (_formKey.currentState!.validate()) {
                    try {
                      await widget.auth.currentUser!.updateEmail(_newEmail);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Email updated successfully'),
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error updating email: ${e.message}'),
                        ),
                      );
                    }
                  }
                },
                child: Text('Update email'),
              ),
              SizedBox(height: 24.0),
              Text(
                'Change password',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              InputField(
                'New password',
                Icons.lock,
                _passwordController,
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  _newPassword = _passwordController.text.trim();
                  if (_formKey.currentState!.validate()) {
                    try {
                      await widget.auth.currentUser!
                          .updatePassword(_newPassword);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Password updated successfully'),
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Error updating password: ${e.message}'),
                        ),
                      );
                    }
                  }
                },
                child: Text('Update password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
