import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/listings_provider.dart';
import '../models/listing_model.dart';
import '../widgets/ui_helpers.dart';
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
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => context.read<ListingsProvider>().setSearchQuery(v),
            ),
          ),
          Consumer<ListingsProvider>(
            builder: (context, provider, _) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: categories.map((cat) {
                    final isSelected = provider.selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(cat, style: GoogleFonts.dmSans(
                          color: isSelected ? Colors.white : kCream,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        )),
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
                      return ListView(
                        padding: const EdgeInsets.all(16),
                        children: List.generate(6, (_) => kShimmerCard()),
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
                            const Icon(Icons.search_off, color: kMuted, size: 56),
                            const SizedBox(height: 16),
                            Text('No listings found', style: GoogleFonts.dmSans(fontSize: 15, color: kMuted)),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final listing = snapshot.data![index];
                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            leading: kCategoryBadge(listing.category),
                            title: Text(listing.name, style: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: kCream,
                            )),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: kGreen.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    listing.category,
                                    style: GoogleFonts.dmSans(fontSize: 11, color: kGreenLight),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  listing.address,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.dmSans(fontSize: 12, color: kMuted),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right_rounded, color: kTerra),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: listing)),
                            ),
                          ),
                        ).animate(delay: (index * 50).ms).fadeIn(duration: 350.ms).slideX(begin: 0.05);
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
