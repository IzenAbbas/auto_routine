import 'package:auto_routine/authentication/signin.dart';
import 'package:auto_routine/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> deleteAccount(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: isLight ? appBackground[0] : appBackground[1],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isLight ? primaryText[0] : primaryText[1],
          ),
        ),
        content: Text(
          'Are you sure you want to delete your account? This action is permanent and cannot be undone.',
          style: TextStyle(
            color: isLight ? secondaryText[0] : secondaryText[1],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isLight ? secondaryText[0] : secondaryText[1],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    },
  );

  if (confirmed != true) return;

  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await user.delete();

    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SignIn()),
      (route) => false,
    );
  } on FirebaseAuthException catch (e) {
    if (!context.mounted) return;
    String message;
    if (e.code == 'requires-recent-login') {
      message = 'Please sign out, sign back in, and try again.';
    } else {
      message = e.message ?? 'Failed to delete account.';
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
