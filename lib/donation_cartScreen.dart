import 'package:flutter/material.dart';

class DonationCartScreen extends StatefulWidget {
  const DonationCartScreen({super.key});

  @override
  State<DonationCartScreen> createState() => _DonationCartScreenState();
}

class _DonationCartScreenState extends State<DonationCartScreen> {
  final items = [
    {
      'name': 'Hauser XO Pen Set (Blue)',
      'price': 100,
      'quantity': 1,
      'image':
          'https://img.freepik.com/premium-photo/pens-pencils-white-background_93675-123314.jpg?w=1380'
    },
    {
      'name': 'Worldone Essential Stationery Kit',
      'price': 200,
      'quantity': 1,
      'image':
          'https://img.freepik.com/free-photo/top-view-assortment-notebooks-wooden-desk_23-2148415046.jpg?w=740'
    },
    {
      'name': 'Nataraj Best of Luck Stationery Kit',
      'price': 150,
      'quantity': 1,
      'image':
          'https://img.freepik.com/free-photo/top-view-assortment-notebooks-wooden-desk_23-2148415046.jpg?w=740'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9575CD), Color(0xFFCE93D8), Colors.white],
            stops: [0.0, 0.6, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Impact Cart!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Selected NGO: Hope NGO',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: items.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item['image'] as String,
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item['name'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '₹${item['price']}',
                              style: const TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF26A69A).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 18, color: Color(0xFF26A69A)),
                                    onPressed: () {
                                      setState(() {
                                        if (item['quantity']! as int > 1) {
                                          item['quantity'] = (item['quantity'] as int) - 1;
                                        }
                                      });
                                    },
                                  ),
                                  Text('${item['quantity']}'),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 18, color: Color(0xFF26A69A)),
                                    onPressed: () {
                                      setState(() {
                                        item['quantity'] = (item['quantity'] as int) + 1;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Total: ₹${items.fold<int>(0, (sum, item) => sum + ((item['price'] as int) * (item['quantity'] as int)))}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF26A69A),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text(
                      'Proceed to Donate',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
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
