import 'package:flutter/material.dart';

class DonationCartScreen extends StatefulWidget {
  const DonationCartScreen({super.key});

  @override
  State<DonationCartScreen> createState() => _DonationCartScreenState();
}

class _DonationCartScreenState extends State<DonationCartScreen> {
  final items = [
    {'name': 'Books', 'quantity': 10},
    {'name': 'Stationery', 'quantity': 20},
  ];
  String donationType = 'One-Time';
  String frequency = 'Monthly';
  bool autoRenew = false;
  bool reminders = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donation Cart')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selected NGO: Hope NGO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Items', style: TextStyle(fontWeight: FontWeight.bold)),
            ...items.map((item) => ListTile(
                  title: Text(item['name'] as String),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => setState(() => item['quantity'] = (item['quantity'] as int) - 1),
                        icon: const Icon(Icons.remove),
                      ),
                      Text('${item['quantity']}'),
                      IconButton(
                        onPressed: () => setState(() => item['quantity'] = (item['quantity'] as int) + 1),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            const Text('Donation Type', style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile(
              title: const Text('One-Time Donation'),
              value: 'One-Time',
              groupValue: donationType,
              onChanged: (value) => setState(() => donationType = value!),
            ),
            RadioListTile(
              title: const Text('Subscription'),
              value: 'Subscription',
              groupValue: donationType,
              onChanged: (value) => setState(() => donationType = value!),
            ),
            if (donationType == 'Subscription') ...[
              DropdownButtonFormField<String>(
                value: frequency,
                items: ['Monthly', 'Quarterly', 'Annually']
                    .map((freq) => DropdownMenuItem(value: freq, child: Text(freq)))
                    .toList(),
                onChanged: (value) => setState(() => frequency = value!),
                decoration: const InputDecoration(labelText: 'Frequency'),
              ),
              SwitchListTile(
                title: const Text('Auto-Renew'),
                value: autoRenew,
                onChanged: (value) => setState(() => autoRenew = value),
              ),
              SwitchListTile(
                title: const Text('Reminders'),
                value: reminders,
                onChanged: (value) => setState(() => reminders = value),
              ),
            ],
            const SizedBox(height: 16),
            const Text('Your Impact', style: TextStyle(fontWeight: FontWeight.bold)),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Impact Streak: 2 months', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Milestone: First Donation Badge Unlocked', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: 0.6, backgroundColor: Colors.grey.shade300),
                    const SizedBox(height: 8),
                    const Text('3/5 donations to next badge'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/confirm-donation'),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}