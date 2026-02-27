import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../providers/listings_provider.dart';
import '../models/listing_model.dart';
import '../widgets/ui_helpers.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _latController = TextEditingController(text: '-1.9441');
  final _lngController = TextEditingController(text: '30.0619');
  String _category = 'Restaurant';

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Place')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              dropdownColor: kSurface2,
              style: GoogleFonts.dmSans(color: kCream),
              items: ['Restaurant', 'Hospital', 'School', 'Hotel', 'Shop', 'Bank', 'Other']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _latController,
              decoration: const InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lngController,
              decoration: const InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            kGradientButton(
              'Add Listing',
              () async {
                if (_formKey.currentState!.validate()) {
                  final lat = double.tryParse(_latController.text);
                  final lng = double.tryParse(_lngController.text);
                  if (lat == null || lng == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Invalid coordinates', style: GoogleFonts.dmSans()),
                        backgroundColor: kTerra,
                      ),
                    );
                    return;
                  }
                  final listing = ListingModel(
                    name: _nameController.text,
                    category: _category,
                    description: _descController.text,
                    address: _addressController.text,
                    phoneNumber: _phoneController.text,
                    latitude: lat,
                    longitude: lng,
                    createdBy: context.read<AuthProvider>().currentUser!.uid,
                    createdAt: DateTime.now(),
                  );
                  await context.read<ListingsProvider>().createListing(listing);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              icon: Icons.add_location,
            ),
          ],
        ).animate().fadeIn(duration: 400.ms),
      ),
    );
  }
}
