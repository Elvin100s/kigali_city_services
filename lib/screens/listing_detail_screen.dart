import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/listing_model.dart';
import 'edit_listing_screen.dart';

class ListingDetailScreen extends StatelessWidget {
  final ListingModel listing;
  final bool canEdit;

  const ListingDetailScreen({super.key, required this.listing, this.canEdit = false});

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
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
                  icon: const Icon(Icons.edit),
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
          Container(
            height: 300,
            color: Colors.grey.shade300,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 80, color: Colors.grey.shade600),
                      const SizedBox(height: 16),
                      Text('Map View', style: TextStyle(fontSize: 20, color: Colors.grey.shade600)),
                      const SizedBox(height: 8),
                      Text('Lat: ${listing.latitude}, Lng: ${listing.longitude}', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(listing.category, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listing.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(listing.description, style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 20),
                _buildInfoRow(Icons.location_on, listing.address, Colors.red),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.phone, listing.phoneNumber, Colors.green),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${listing.latitude},${listing.longitude}');
                      if (await canLaunchUrl(url)) await launchUrl(url);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.directions),
                    label: const Text('Get Directions', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
