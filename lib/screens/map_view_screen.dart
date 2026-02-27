import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/listings_provider.dart';
import '../models/listing_model.dart';
import '../widgets/ui_helpers.dart';
import 'listing_detail_screen.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  List<Marker> _buildMarkers(List<ListingModel> listings) {
    return listings.map((listing) {
      return Marker(
        point: LatLng(listing.latitude, listing.longitude),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListingDetailScreen(listing: listing),
              ),
            );
          },
          child: const Column(
            children: [
              Icon(Icons.location_on, color: Colors.red, size: 40),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final listingsProvider = context.read<ListingsProvider>();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Map View')),
      body: StreamBuilder<List<ListingModel>>(
        stream: listingsProvider.listingsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: kGreenLight),
                  const SizedBox(height: 16),
                  Text('Loading map...', style: GoogleFonts.dmSans(color: kMuted)),
                ],
              ),
            );
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: kTerra, size: 56),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}', style: GoogleFonts.dmSans(color: kMuted)),
                ],
              ),
            );
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map_outlined, color: kMuted, size: 56),
                  const SizedBox(height: 16),
                  Text('No listings available', style: GoogleFonts.dmSans(fontSize: 15, color: kMuted)),
                ],
              ),
            );
          }

          final listings = snapshot.data!;

          return FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(-1.9441, 30.0619),
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.kigali_city_services',
              ),
              MarkerLayer(
                markers: _buildMarkers(listings),
              ),
            ],
          );
        },
      ),
    );
  }
}
