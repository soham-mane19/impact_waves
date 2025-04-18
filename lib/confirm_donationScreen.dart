import 'package:flutter/material.dart';
import 'package:impact_waves/constants.dart';
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
    final totalItems = items.fold<int>(0, (sum, item) => sum + (item['quantity'] as int));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Confirm Donation',style: TextStyle(fontWeight: FontWeight.w500,fontFamily: kFontFamilyMonstreet),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);  
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        
              ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card: Glassmorphism Style
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                 
                  ),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text(
                      'Donation Summary',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      Text('NGO: Hope NGO', style: TextStyle(fontSize: 16, color: Colors.grey.shade800)),
                      const SizedBox(height: 16),
                      ...items.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item['name'] as String, style: const TextStyle(fontSize: 16)),
                                Text('x${item['quantity']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                          ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Items',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text('$totalItems',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Time restriction warning
                if (!isOperating) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.red),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Orders can only be placed between 9 AM - 5 PM. Please schedule for tomorrow.',
                            style: TextStyle(color: Colors.red.shade800),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          scheduledTime != null
                              ? 'Scheduled: ${DateFormat('MMM d, yyyy – h:mm a').format(scheduledTime!)}'
                              : 'No schedule selected',
                          style: const TextStyle(fontSize: 16),
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
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Pick Schedule'),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 40),
                // Action Button
                Center(
                  child: ElevatedButton(
                    onPressed: isOperating || scheduledTime != null
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isOperating
                                      ? 'Order placed successfully!'
                                      : 'Order scheduled for ${DateFormat('MMM d, yyyy – h:mm a').format(scheduledTime!)}',
                                ),
                                backgroundColor: Colors.green.shade600,
                              ),
                            );
                            Navigator.pushNamed(context, '/delivery-updates');
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 8,
                    ),
                    child: Text(isOperating ? 'Place Order' : 'Schedule Order'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
