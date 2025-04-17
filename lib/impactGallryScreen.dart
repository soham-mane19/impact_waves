import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:impact_waves/constants.dart';

class ImpactGalleryScreen extends StatelessWidget {
  const ImpactGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
   final galleryImages = [
  'https://img.freepik.com/free-photo/portrait-young-boy_23-2150773172.jpg?uid=R150848235&ga=GA1.1.1168601080.1744699300&semt=ais_hybrid&w=740', // School kids
  'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fG5nb3xlbnwwfHwwfHx8MA%3D%3D', // Volunteers packing food
  'https://img.freepik.com/free-photo/wise-senior-man-posing-studio-side-view_23-2149883515.jpg?uid=R150848235&ga=GA1.1.1168601080.1744699300&semt=ais_hybrid&w=740', // Old age home support
  'https://img.freepik.com/free-photo/side-view-old-man-portrait_23-2151056596.jpg?uid=R150848235&ga=GA1.1.1168601080.1744699300&semt=ais_hybrid&w=740', // Woman helping children
  'https://img.freepik.com/premium-photo/boy-is-sitting-desk-with-board-that-says-school-it_1153744-49309.jpg?uid=R150848235&ga=GA1.1.1168601080.1744699300&semt=ais_hybrid&w=740', // Food distribution
  'https://img.freepik.com/premium-photo/acts-charity-prevalent-makar-sankranti-with-volunteers-distributing-warm-clothes-food-s_950002-605277.jpg?w=1380', // Children holding books
];

    final stories = [
      {
        'title': 'You Educated Futures ✏️',
        'description': 'Your book donations reached 30 rural school kids, sparking curiosity and dreams.'
      },
      {
        'title': 'You Gave Dignity 💝',
        'description': 'Senior citizens at a care home received daily essentials, feeling seen and supported.'
      },
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFfdfcfb), Color(0xFFe2d1c3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✨ Emotional Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFff9a9e), Color(0xFFfad0c4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '🌟 Thank You for Making an Impact!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: kFontFamilyMonstreet
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '"No act of kindness, no matter how small, is ever wasted."',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                          fontFamily: kFontFamilyMonstreet
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                const Text(
                  '📸 Impact Moments',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6d4c41),fontFamily: kFontFamilyMonstreet),
                ),
                const SizedBox(height: 16),

                MasonryGridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  itemCount: galleryImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          galleryImages[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),
                const Text(
                  '💌 Real Stories of Change',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4e342e),fontFamily: kFontFamilyMonstreet),
                ),
                const SizedBox(height: 12),

                ...stories.map((story) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFffe0b2), Color(0xFFfff3e0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story['title']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0xFF6d4c41),
                                fontFamily: kFontFamilyMonstreet
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              story['description']!,
                              style: const TextStyle(fontSize: 14, color: Colors.black87,fontFamily: kFontFamilyMonstreet),
                            ),
                          ],
                        ),
                      ),
                    )),

                const SizedBox(height: 40),
                Center(
                  child: Text(
                    "✨ You didn’t just give – you changed lives.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade700,
                      fontFamily: kFontFamilyMonstreet
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
