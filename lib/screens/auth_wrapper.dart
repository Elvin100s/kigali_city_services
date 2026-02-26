import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'otp_verification_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    
    return StreamBuilder(
      stream: authProvider.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        if (snapshot.hasData) {
          final user = snapshot.data;
          if (user != null) {
            return FutureBuilder<bool>(
              future: authProvider.isUserVerified(),
              builder: (context, verificationSnapshot) {
                if (verificationSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                
                if (verificationSnapshot.data == true) {
                  return const HomeScreen();
                } else {
                  return const OtpVerificationScreen();
                }
              },
            );
          }
        }
        
        return const LoginScreen();
      },
    );
  }
}
