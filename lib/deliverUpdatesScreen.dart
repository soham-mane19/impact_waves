import 'package:flutter/material.dart';
import 'package:impact_waves/constants.dart';

class DeliveryUpdatesScreen extends StatelessWidget {
  const DeliveryUpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const status = 'Shipped';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Delivery Updates',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,  // Bold, vibrant color for AppBar
        elevation: 0,
         leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Timeline
              const Text(
                'Delivery Timeline',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TimelineStep(label: 'Placed', isActive: true),
                  _TimelineStep(label: 'Shipped', isActive: status == 'Shipped' || status == 'Delivered'),
                  _TimelineStep(label: 'Delivered', isActive: status == 'Delivered'),
                ],
              ),
              const SizedBox(height: 40),

              // NGO Acknowledgment Section
              const Text(
                'NGO Acknowledgment',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                shadowColor: Colors.black.withOpacity(0.15),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          'https://media.istockphoto.com/id/536251515/photo/pretty-hispanic-child-holding-thank-you-sign-at-food-bank.jpg?s=2048x2048&w=is&k=20&c=x6J9LQoomEEoURRo0cHkD3hCMDuCK8fPcTorSmHxryY=',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Your donation helped provide books to 30 kids. Thank you!',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                          fontFamily: kFontFamilyMonstreet,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Thank You for Supporting Our Cause!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent,
                  fontFamily: kFontFamilyMonstreet,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // View Impact Button
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/impact-gallery'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'View Impact',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String label;
  final bool isActive;

  const _TimelineStep({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            isActive ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isActive ? Colors.blueAccent : Colors.grey[400],
            size: 40,
            key: ValueKey<bool>(isActive),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isActive ? Colors.blueAccent : Colors.grey[400],
            fontWeight: FontWeight.w500,
            fontFamily: kFontFamilyMonstreet,
          ),
        ),
      ],
    );
  }
}
