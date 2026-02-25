import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/listings_provider.dart';
import '../models/listing_model.dart';
import 'add_listing_screen.dart';
import 'listing_detail_screen.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthProvider>().currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('My Listings')),
      body: StreamBuilder<List<ListingModel>>(
        stream: context.read<ListingsProvider>().getUserListingsStream(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No listings yet. Add your first!'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final listing = snapshot.data![index];
              return ListTile(
                title: Text(listing.name),
                subtitle: Text('${listing.category} • ${listing.address}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Listing'),
                        content: const Text('Are you sure?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                        ],
                      ),
                    );
                    if (confirm == true && context.mounted) {
                      await context.read<ListingsProvider>().deleteListing(listing.id!);
                    }
                  },
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: listing, canEdit: true)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddListingScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
