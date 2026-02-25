import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/listings_provider.dart';
import '../models/listing_model.dart';
import 'listing_detail_screen.dart';

class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({super.key});

  static const categories = ['All', 'Restaurant', 'Hospital', 'School', 'Hotel', 'Shop', 'Bank', 'Other'];

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Restaurant': return Icons.restaurant;
      case 'Hospital': return Icons.local_hospital;
      case 'School': return Icons.school;
      case 'Hotel': return Icons.hotel;
      case 'Shop': return Icons.shopping_bag;
      case 'Bank': return Icons.account_balance;
      default: return Icons.place;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directory'),
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue.shade700,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
                        selectedColor: Colors.blue.shade700,
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
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
                      padding: const EdgeInsets.all(16),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final listing = snapshot.data![index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Icon(_getCategoryIcon(listing.category), color: Colors.blue.shade700),
                            ),
                            title: Text(listing.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(listing.category),
                                Text(listing.address, maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                            trailing: Icon(Icons.chevron_right, color: Colors.blue.shade700),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: listing)),
                            ),
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
