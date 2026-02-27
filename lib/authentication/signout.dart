import 'package:auto_routine/authentication/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  if (!context.mounted) return;
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const SignIn()),
    (route) => false,
  );
}
