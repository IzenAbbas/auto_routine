import 'package:auto_routine/authentication/deleteAcc.dart';
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

    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (context, light, _) {
        return Scaffold(
          backgroundColor: light ? appBackground[0] : appBackground[1],
          appBar: AppBar(
            backgroundColor: light ? appBackground[0] : appBackground[1],
            title: Text(
              'Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: light ? primaryText[0] : primaryText[1],
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => deleteAccount(context),
                icon: Icon(Icons.delete, color: Colors.redAccent),
                tooltip: 'Delete Account',
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
                      color: light ? primaryText[0] : primaryText[1],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      color: light ? secondaryText[0] : secondaryText[1],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: light
                          ? Colors.grey.shade100
                          : Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              light ? Icons.light_mode : Icons.dark_mode,
                              color: light ? primaryText[0] : primaryText[1],
                            ),
                            const SizedBox(width: 12),
                            Text(
                              light ? 'Light Mode' : 'Dark Mode',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: light ? primaryText[0] : primaryText[1],
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: light,
                          activeColor: primaryAccent,
                          onChanged: (value) {
                            isLight = value;
                          },
                        ),
                      ],
                    ),
                  ),
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
      },
    );
  }
}
