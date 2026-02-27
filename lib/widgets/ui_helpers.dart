import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

// Theme colors
const kBg = Color(0xFF0D1117);
const kSurface = Color(0xFF161B22);
const kSurface2 = Color(0xFF1C2230);
const kGreen = Color(0xFF2D6A4F);
const kGreenLight = Color(0xFF52B788);
const kTerra = Color(0xFFC1440E);
const kGold = Color(0xFFD4A853);
const kCream = Color(0xFFE8E0D4);
const kMuted = Color(0xFF8B8680);

// Gradient button
Widget kGradientButton(String label, VoidCallback? onPressed, {IconData? icon}) {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [kGreen, kGreenLight]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: kGreen.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: icon != null
            ? Icon(icon, color: Colors.white, size: 18)
            : const SizedBox.shrink(),
        label: Text(
          label,
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}

// Category icon badge
Widget kCategoryBadge(String category) {
  final data = {
    'Hospital': [Icons.local_hospital_rounded, const Color(0xFFE05A28)],
    'Police': [Icons.local_police_rounded, const Color(0xFF3A86FF)],
    'Library': [Icons.menu_book_rounded, const Color(0xFFD4A853)],
    'Restaurant': [Icons.restaurant_rounded, const Color(0xFFFF6B6B)],
    'Café': [Icons.coffee_rounded, const Color(0xFFA0522D)],
    'Park': [Icons.park_rounded, const Color(0xFF52B788)],
    'Attraction': [Icons.photo_camera_rounded, const Color(0xFFBB86FC)],
    'Bank': [Icons.account_balance_rounded, const Color(0xFF2D6A4F)],
    'Hotel': [Icons.hotel_rounded, const Color(0xFF4ECDC4)],
    'School': [Icons.school_rounded, const Color(0xFF9B59B6)],
    'Shop': [Icons.shopping_bag_rounded, const Color(0xFFE74C3C)],
    'Other': [Icons.place_rounded, const Color(0xFF8B8680)],
  };
  final d = data[category] ?? data['Other']!;
  final color = d[1] as Color;
  return Container(
    width: 46,
    height: 46,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Icon(d[0] as IconData, color: color, size: 20),
  );
}

// Shimmer placeholder card
Widget kShimmerCard() => Shimmer.fromColors(
      baseColor: kSurface,
      highlightColor: kSurface2,
      child: Container(
        height: 76,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
