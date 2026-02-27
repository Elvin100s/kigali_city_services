import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/listing_model.dart';
import '../widgets/ui_helpers.dart';
import 'edit_listing_screen.dart';

class ListingDetailScreen extends StatelessWidget {
  final ListingModel listing;
  final bool canEdit;

  const ListingDetailScreen({super.key, required this.listing, this.canEdit = false});

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.dmSans(fontSize: 14, color: kCream),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listing.name),
        actions: canEdit
            ? [
                IconButton(
                  icon: const Icon(Icons.edit, color: kGold),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditListingScreen(listing: listing)),
                  ),
                ),
              ]
            : null,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 250,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(listing.latitude, listing.longitude),
                      initialZoom: 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.kigali_city_services',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(listing.latitude, listing.longitude),
                            width: 40,
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                color: kGreen,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kGreen.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kGreenLight),
                    ),
                    child: Text(
                      listing.category,
                      style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listing.name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: kCream,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: kSurface2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    listing.description,
                    style: GoogleFonts.dmSans(fontSize: 14, color: kCream, height: 1.5),
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoRow(Icons.location_on, listing.address, kTerra),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.phone, listing.phoneNumber, kGreenLight),
                const SizedBox(height: 24),
                kGradientButton(
                  'Get Directions',
                  () async {
                    final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${listing.latitude},${listing.longitude}');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: Icons.directions,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse('tel:${listing.phoneNumber}');
                    if (await canLaunchUrl(url)) await launchUrl(url);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kTerra),
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.phone, color: kTerra),
                  label: Text('Call', style: GoogleFonts.dmSans(color: kTerra, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
