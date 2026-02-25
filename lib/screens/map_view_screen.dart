import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/listings_provider.dart';
import '../models/listing_model.dart';
import 'listing_detail_screen.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map View')),
      body: StreamBuilder<List<ListingModel>>(
        stream: context.read<ListingsProvider>().listingsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final listings = snapshot.data!;
          final markers = listings.map((listing) {
            return Marker(
              markerId: MarkerId(listing.id ?? ''),
              position: LatLng(listing.latitude, listing.longitude),
              infoWindow: InfoWindow(
                title: listing.name,
                snippet: listing.category,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: listing)),
                ),
              ),
            );
          }).toSet();

          return GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(-1.9441, 30.0619),
              zoom: 12,
            ),
            markers: markers,
            onMapCreated: (controller) => _controller = controller,
          );
        },
      ),
    );
  }
}
