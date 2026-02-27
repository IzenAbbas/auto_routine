import 'package:auto_routine/authentication/signout.dart';
import 'package:auto_routine/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CurrentuserDetails extends StatefulWidget {
  const CurrentuserDetails({super.key});

  @override
  State<CurrentuserDetails> createState() => _CurrentuserDetailsState();
}

class _CurrentuserDetailsState extends State<CurrentuserDetails> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: isLight ? appBackground[0] : appBackground[1],
      appBar: AppBar(
        backgroundColor: isLight ? appBackground[0] : appBackground[1],
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isLight ? primaryText[0] : primaryText[1],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => signOut(context),
            icon: Icon(
              Icons.logout,
              color: isLight ? primaryText[0] : primaryText[1],
            ),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: primaryAccent,
                child: Text(
                  (user?.displayName ?? 'U')[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: primaryText[0],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user?.displayName ?? 'User',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isLight ? primaryText[0] : primaryText[1],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                user?.email ?? '',
                style: TextStyle(
                  color: isLight ? secondaryText[0] : secondaryText[1],
                ),
              ),
              const SizedBox(height: 32),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => signOut(context),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Sign Out',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
