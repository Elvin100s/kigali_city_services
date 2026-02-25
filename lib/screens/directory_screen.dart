import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/listings_provider.dart';
import '../models/listing_model.dart';
import 'listing_detail_screen.dart';

class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({super.key});

  static const categories = ['All', 'Restaurant', 'Hospital', 'School', 'Hotel', 'Shop', 'Bank', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Directory')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => context.read<ListingsProvider>().setSearchQuery(v),
            ),
          ),
          Consumer<ListingsProvider>(
            builder: (context, provider, _) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: categories.map((cat) {
                    final isSelected = provider.selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) => provider.setCategory(cat),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          Expanded(
            child: Consumer<ListingsProvider>(
              builder: (context, provider, _) {
                return StreamBuilder<List<ListingModel>>(
                  stream: provider.getFilteredListingsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No listings found'));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final listing = snapshot.data![index];
                        return ListTile(
                          title: Text(listing.name),
                          subtitle: Text('${listing.category} • ${listing.address}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: listing)),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
