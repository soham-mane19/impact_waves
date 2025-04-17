import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:impact_waves/constants.dart';
import 'package:impact_waves/ngo_detailScreen.dart';

class NgoListingScreen extends StatelessWidget {
  const NgoListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample NGO data with real Unsplash images
    final ngos = [
      {
        'name': 'Hope NGO',
        'mission': 'Empowering kids through education.',
        'verified': true,
        'needs': [
          {'item': 'Books', 'quantity': 100, 'impact': 'Helps 50 kids'},
          {'item': 'Stationery', 'quantity': 200, 'impact': 'Supports 100 students'},
        ],
        'photos': [
          'https://plus.unsplash.com/premium_photo-1682092585257-58d1c813d9b4?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fG5nb3xlbnwwfHwwfHx8MA%3D%3D',
        ],
        'stories': [
          {
            'title': 'School Supplies Drive',
            'description': 'Provided books to 50 rural kids.',
            'image': 'https://plus.unsplash.com/premium_photo-1682092618317-9b50d60e6e0d?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          },
          {
            'title': 'Learning Centers',
            'description': 'Set up 3 new classrooms.',
            'image': 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f',
          },
        ],
      },
      {
        'name': 'Care Foundation',
        'mission': 'Supporting elderly communities.',
        'verified': true,
        'needs': [
          {'item': 'Medical Kits', 'quantity': 50, 'impact': 'Aids 50 seniors'},
          {'item': 'Blankets', 'quantity': 100, 'impact': 'Warms 100 elders'},
        ],
        'photos': [
          'https://media.istockphoto.com/id/474264614/photo/stressed-businessman.webp?a=1&b=1&s=612x612&w=0&k=20&c=XQ46bapBcdhOr6oe4_7J-h4wr58AfJCl1aU7kyTwOnM=',
          'https://as1.ftcdn.net/v2/jpg/01/94/01/50/1000_F_194015021_DxwDTnL0rZpJQdmA8BoxEI0lct2YHMgL.jpg',
        ],
        'stories': [
          {
            'title': 'Senior Healthcare',
            'description': 'Funded checkups for 30 elders.',
            'image': 'https://media.istockphoto.com/id/2155992142/photo/cleanup-people-and-volunteers-planning-with-tablet-for-support-community-project-or-nature.webp?a=1&b=1&s=612x612&w=0&k=20&c=vzAnly3ATQ7vtOJfrmvbYiOGtgkepNQu-SkHZsveuhI=',
          },
        ],
      },
    ];

    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
        title: const Text(
          'Discover NGOs',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,fontFamily: kFontFamilyMonstreet),
        ),
          leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
       
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: ngos.length,
        itemBuilder: (context, index) {
          final ngo = ngos[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NgoDetailsScreen(ngo: ngo),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.grey[50]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Carousel
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: SizedBox(
                        height: 200,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 200,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 1.0,
                          ),
                          items: (ngo['photos'] as List<String>).map((url) {
                            return Hero(
                              tag: 'ngo-image-${ngo['name']}-$url',
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error, color: Colors.red, size: 50);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    // NGO Details
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  ngo['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontFamily: kFontFamilyMonstreet
                                  ),
                                ),
                              ),
                              if (ngo['verified'] as bool)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.verified, color: Colors.green, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        'Verified',
                                        style: TextStyle(color: Colors.green, fontSize: 12,fontFamily: kFontFamilyMonstreet),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ngo['mission'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              height: 1.4,
                              fontFamily: kFontFamilyMonstreet
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          // Needs Preview
                          Row(
                            children: [
                              Icon(Icons.volunteer_activism, color: Colors.teal[300], size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Needs: ${(ngo['needs'] as List).first['item']} (${(ngo['needs'] as List).first['quantity']})',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.teal[700],
                                    fontWeight: FontWeight.w600,
                                    fontFamily: kFontFamilyMonstreet
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Action Button
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NgoDetailsScreen(ngo: ngo),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal[400],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Explore More',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,fontFamily: kFontFamilyMonstreet),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}