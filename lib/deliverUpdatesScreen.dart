import 'package:flutter/material.dart';

class DeliveryUpdatesScreen extends StatelessWidget {
  const DeliveryUpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const status = 'Shipped';
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Updates')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Delivery Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TimelineStep(label: 'Placed', isActive: true),
                _TimelineStep(label: 'Shipped', isActive: status == 'Shipped' || status == 'Delivered'),
                _TimelineStep(label: 'Delivered', isActive: status == 'Delivered'),
              ],
            ),
            const SizedBox(height: 24),
            const Text('NGO Acknowledgment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network('https://media.istockphoto.com/id/536251515/photo/pretty-hispanic-child-holding-thank-you-sign-at-food-bank.jpg?s=2048x2048&w=is&k=20&c=x6J9LQoomEEoURRo0cHkD3hCMDuCK8fPcTorSmHxryY=', height: 100, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your donation helped provide books to 30 kids. Thank you!',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/impact-gallery'),
                child: const Text('View Impact'),
              ),
            ),
          ],
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
        Icon(
          Icons.check_circle,
          color: isActive ? Colors.teal : Colors.grey,
          size: 40,
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: isActive ? Colors.teal : Colors.grey)),
      ],
    );
  }
}