import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/listing_model.dart';
import 'edit_listing_screen.dart';

class ListingDetailScreen extends StatelessWidget {
  final ListingModel listing;
  final bool canEdit;

  const ListingDetailScreen({super.key, required this.listing, this.canEdit = false});

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
          SizedBox(
            height: 250,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(listing.latitude, listing.longitude),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(listing.id ?? ''),
                  position: LatLng(listing.latitude, listing.longitude),
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listing.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(listing.category, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                Text(listing.description),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(listing.address)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 20),
                    const SizedBox(width: 8),
                    Text(listing.phoneNumber),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${listing.latitude},${listing.longitude}');
                    if (await canLaunchUrl(url)) await launchUrl(url);
                  },
                  icon: const Icon(Icons.directions),
                  label: const Text('Get Directions'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
