import 'package:flutter/material.dart';

class SelectRegionScreen extends StatefulWidget {
  const SelectRegionScreen({super.key});

  @override
  State<SelectRegionScreen> createState() => _SelectRegionScreenState();
}

class _SelectRegionScreenState extends State<SelectRegionScreen> {
  String? selectedState;
  final causes = [
    {'name': 'Animal Care', 'icon': Icons.pets},
    {'name': 'Elder Care', 'icon': Icons.elderly},
    {'name': 'Education', 'icon': Icons.book},
    {'name': 'Disability Support', 'icon': Icons.accessible},
  ];
  final List<String> selectedCauses = []; // Track selected causes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Region & Cause'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select State',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.teal.shade50,
              ),
              value: selectedState,
              items: ['Maharashtra', 'Karnataka', 'Delhi', 'Haryana']
                  .map((state) => DropdownMenuItem(
                        value: state,
                        child: Text(state),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => selectedState = value),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Cause',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: causes.map((cause) {
                  final isSelected = selectedCauses.contains(cause['name']);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedCauses.remove(cause['name']);
                        } else {
                          selectedCauses.add(cause['name'] as String);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.identity()..scale(isSelected ? 1.05 : 1.0),
                      width: 160,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isSelected
                              ? [Colors.teal.shade400, Colors.teal.shade600]
                              : [Colors.teal.shade100, Colors.teal.shade300],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: Colors.teal.shade900, width: 2)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: isSelected ? 8 : 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Icon(
                                cause['icon'] as IconData,
                                size: 40,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                cause['name'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          if (isSelected)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.teal.shade600,
                                  size: 24,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: selectedState != null && selectedCauses.isNotEmpty
                    ? () {
                        // Pass selected state and causes to the next screen
                        Navigator.pushNamed(
                          context,
                          '/ngo-listing',
                          arguments: {
                            'state': selectedState,
                            'causes': selectedCauses,
                          },
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}