import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ImpactGalleryScreen extends StatelessWidget {
  const ImpactGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final galleryImages = List.generate(6, (index) => 'https://via.placeholder.com/150');
    final stories = [
      {'title': 'Helped 30 Kids', 'description': 'Your book donations reached a rural school.'},
      {'title': 'Supported Elders', 'description': 'Your supplies aided a senior care home.'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Impact & Stories')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Impact Gallery', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            MasonryGridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: galleryImages.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(galleryImages[index], fit: BoxFit.cover),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('Your Stories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...stories.map((story) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(story['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(story['description']!),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}