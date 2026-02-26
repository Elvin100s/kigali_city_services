import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get otpCode => _controllers.map((c) => c.text).join();

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyOtp() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    
    if (user == null || otpCode.length != 6) return;
    
    final success = await authProvider.verifyOtp(user.email!, otpCode);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verified successfully!'),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppTheme.buttonRadius),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLG),
              child: Column(
                children: [
                  const Spacer(),
                  
                  // Header Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: AppTheme.buttonShadow,
                    ),
                    child: const Icon(
                      Icons.security_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // Title
                  const Text(
                    'Enter Verification Code',
                    style: AppTheme.headingLarge,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingMD),
                  
                  // Subtitle
                  Text(
                    'We sent a 6-digit code to\n${authProvider.currentUser?.email}',
                    style: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXXL),
                  
                  // OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 50,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: AppTheme.inputRadius,
                          border: Border.all(
                            color: _controllers[index].text.isNotEmpty 
                                ? AppTheme.primaryColor 
                                : AppTheme.borderColor,
                            width: 2,
                          ),
                          boxShadow: AppTheme.cardShadow,
                        ),
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: AppTheme.headingMedium.copyWith(
                            color: AppTheme.primaryColor,
                          ),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (value) {
                            _onChanged(value, index);
                            setState(() {});
                          },
                        ),
                      );
                    }),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXXL),
                  
                  // Error Message
                  if (authProvider.error != null)
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingMD),
                      margin: const EdgeInsets.only(bottom: AppTheme.spacingLG),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor.withValues(alpha: 0.1),
                        borderRadius: AppTheme.buttonRadius,
                        border: Border.all(color: AppTheme.errorColor.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppTheme.errorColor, size: 20),
                          const SizedBox(width: AppTheme.spacingSM),
                          Expanded(
                            child: Text(
                              authProvider.error!,
                              style: AppTheme.bodyMedium.copyWith(color: AppTheme.errorColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Verify Button
                  AppTheme.gradientButton(
                    text: 'Verify Code',
                    onPressed: _verifyOtp,
                    isLoading: authProvider.isLoading,
                    width: double.infinity,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingLG),
                  
                  // Resend Code
                  TextButton(
                    onPressed: authProvider.isLoading 
                        ? null 
                        : () => authProvider.resendOtp(authProvider.currentUser!.email!),
                    child: Text(
                      'Resend Code',
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingSM),
                  
                  // Logout
                  TextButton(
                    onPressed: () => authProvider.signOut(),
                    child: Text(
                      'Logout',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}