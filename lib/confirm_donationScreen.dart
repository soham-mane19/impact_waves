import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfirmDonationScreen extends StatefulWidget {
  const ConfirmDonationScreen({super.key});

  @override
  State<ConfirmDonationScreen> createState() => _ConfirmDonationScreenState();
}

class _ConfirmDonationScreenState extends State<ConfirmDonationScreen> {
  DateTime? scheduledTime;
  final items = [
    {'name': 'Books', 'quantity': 10},
    {'name': 'Stationery', 'quantity': 20},
  ];

  bool isWithinOperatingHours() {
    final now = DateTime.now();
    final hour = now.hour;
    return hour >= 9 && hour < 17; // 9 AM to 5 PM
  }

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    final isOperating = isWithinOperatingHours();
    final totalItems = items.fold<int>(0, (sum, item) => sum + (item['quantity'] as int));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Donation'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Donation Summary Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade100, Colors.teal.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Donation Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'NGO: Hope NGO',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    ...items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item['name']}',
                                style: const TextStyle(fontSize: 16, color: Colors.white),
                              ),
                              Text(
                                'x${item['quantity']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.teal.shade900,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )),
                    const Divider(color: Colors.white54, height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Items',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$totalItems',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Time Restriction Section
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: isOperating ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.red.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Orders can only be placed between 9 AM - 5 PM. Schedule for tomorrow at 9 AM.',
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          scheduledTime != null
                              ? 'Scheduled: ${DateFormat('MMM d, yyyy, h:mm a').format(scheduledTime!)}'
                              : 'No schedule selected',
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final tomorrow = DateTime.now().add(const Duration(days: 1));
                          final picked = await showDateTimePicker(
                            context: context,
                            initialDate: tomorrow,
                            firstDate: tomorrow,
                            lastDate: DateTime.now().add(const Duration(days: 30)),
                          );
                          if (picked != null) {
                            setState(() => scheduledTime = picked);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Pick Schedule'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Action Button
            Center(
              child: ElevatedButton(
                onPressed: isOperating || scheduledTime != null
                    ? () {
                        // Handle order placement or scheduling
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isOperating
                                  ? 'Order placed successfully!'
                                  : 'Order scheduled for ${DateFormat('MMM d, yyyy, h:mm a').format(scheduledTime!)}',
                            ),
                            backgroundColor: Colors.teal,
                          ),
                        );
                        Navigator.pushNamed(context, '/delivery-updates');
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: Text(isOperating ? 'Place Order' : 'Schedule Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}