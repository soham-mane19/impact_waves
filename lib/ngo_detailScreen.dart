import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class NgoDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> ngo;

  const NgoDetailsScreen({super.key, required this.ngo});

  @override
  State<NgoDetailsScreen> createState() => _NgoDetailsScreenState();
}

class _NgoDetailsScreenState extends State<NgoDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.ngo['photos'] as List<String>;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 250,
            floating: false,
            pinned: true,
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.ngo['name'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 2, offset: Offset(0, 1))],
                ),
              ),
              background: Hero(
                tag: 'ngo-image-${widget.ngo['name']}-${photos[0]}',
                child: Image.network(
                  photos[0],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, color: Colors.red);
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.teal.shade50, // Light background for contrast
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.teal.shade900,
                unselectedLabelColor: Colors.teal.shade600,
                indicatorColor: Colors.tealAccent,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                tabs: const [
                  Tab(text: 'Info'),
                  Tab(text: 'Needs'),
                  Tab(text: 'Stories'),
                ],
              ),
            ),
          ),
        ],
        body: Container(
          color: Colors.white,
          child: TabBarView(
            controller: _tabController,
            children: [
              // Info Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.ngo['name'] as String,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (widget.ngo['verified'] as bool)
                          const Icon(Icons.verified, color: Colors.green, size: 24),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.ngo['mission'] as String,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'About Us',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We are dedicated to transforming lives through education and community support. '
                      'Our programs reach thousands of children annually, providing them with essential resources.',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                    ),
                    const SizedBox(height: 16),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 150,
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                      items: photos.map((url) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              // Needs Tab
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Monthly Needs',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...(widget.ngo['needs'] as List).map((need) => Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            '${need['item']} (x${need['quantity']})',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(need['impact']),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${need['quantity']}',
                              style: TextStyle(
                                color: Colors.teal.shade900,
                                fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              // Stories Tab
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Impact Stories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...(widget.ngo['stories'] as List).map((story) => Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.network(
                                story['image'],
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const SizedBox(
                                    height: 150,
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    story['title'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    story['description'],
                                    style: TextStyle(color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/donation-cart'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.card_giftcard),
        label: const Text('Donate Items'),
      ),
    );
  }
}