import 'package:flutter/material.dart';
import 'package:impact_waves/constants.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

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
    return hour >= 9 && hour < 17;
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
    final totalItems =
        items.fold<int>(0, (sum, item) => sum + (item['quantity'] as int));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Confirm Donation'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAF2F8), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Donation Summary',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'NGO: Hope Foundation',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...items.map((item) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['name'].toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'x${item['quantity']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )),
                      const Divider(color: Colors.black12, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Items',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '$totalItems',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 400),
                  crossFadeState: isOperating
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    children: [
                      GlassCard(
                        color: Colors.red.shade50.withOpacity(0.4),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: Colors.redAccent),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Orders can only be placed between 9 AM - 5 PM.\nYou can schedule for tomorrow.',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      GlassCard(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                scheduledTime != null
                                    ? 'Scheduled: ${DateFormat('MMM d, yyyy, h:mm a').format(scheduledTime!)}'
                                    : 'No schedule selected',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final tomorrow =
                                    DateTime.now().add(const Duration(days: 1));
                                final picked = await showDateTimePicker(
                                  context: context,
                                  initialDate: tomorrow,
                                  firstDate: tomorrow,
                                  lastDate: tomorrow.add(const Duration(days: 30)),
                                );
                                if (picked != null) {
                                  setState(() => scheduledTime = picked);
                                }
                              },
                              icon: const Icon(Icons.calendar_today),
                              label: const Text('Pick Schedule'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2C3E50),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: isOperating || scheduledTime != null
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isOperating
                                    ? 'Order placed successfully!'
                                    : 'Order scheduled for ${DateFormat('MMM d, yyyy, h:mm a').format(scheduledTime!)}',
                              ),
                              backgroundColor: Colors.green.shade600,
                            ),
                          );
                          Navigator.pushNamed(context, '/delivery-updates');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C3E50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  child: Text(isOperating ? 'Place Order' : 'Schedule Order'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final Color? color;

  const GlassCard({
    super.key,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color ?? Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
