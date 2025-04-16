import 'package:flutter/material.dart';

class SelectRegionScreen extends StatefulWidget {
  const SelectRegionScreen({super.key});

  @override
  State<SelectRegionScreen> createState() => _SelectRegionScreenState();
}

class _SelectRegionScreenState extends State<SelectRegionScreen> {
  String? selectedState;
  final causes = [
    {'name': 'Medical', 'icon': Icons.local_hospital, 'image': 'assets/medical.jpg'},
    {'name': 'Animals', 'icon': Icons.pets, 'image': 'assets/animals.jpg'},
    {'name': 'Education', 'icon': Icons.school, 'image': 'assets/education.jpg'},
    {'name': 'Food', 'icon': Icons.restaurant, 'image': 'assets/food.jpg'},
  ];
  final List<String> selectedCauses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9575CD), Color(0xFFCE93D8), Colors.white],
            stops: [0.0, 0.6, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Hey, Changemaker!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, color: Color(0xFF9575CD)),
                            ),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '500+',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'NGO Needs Met',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '300+',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Active Donors',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '1,000+',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Items Tracked',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCauseCard('Help anytime, anywhere', Icons.favorite),
                          _buildCauseCard('Give with trust', Icons.verified),
                          _buildCauseCard('Track in Real-Time', Icons.sync),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/impact-gallery');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF26A69A),
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'See Your Impact',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                         
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF9575CD)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        value: selectedState,
                        items: ['Maharashtra', 'Karnataka', 'Delhi', 'Haryana']
                            .map((state) => DropdownMenuItem(
                                  value: state,
                                  child: Text(state, style: TextStyle(fontSize: 16)),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => selectedState = value),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Select Cause',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9575CD),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 400, // Increased height to accommodate all four causes
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          physics: NeverScrollableScrollPhysics(),
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
                              child: Card(
                                color: isSelected ? Color(0xFF26A69A) : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                               
                                    Icon(
                                      cause['icon'] as IconData,
                                      size: 30,
                                      color: isSelected ? Colors.white : Color(0xFF26A69A),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      cause['name'] as String,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.white : Color(0xFF26A69A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 20),
                     
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:  ElevatedButton(
        onPressed: selectedState != null && selectedCauses.isNotEmpty
            ? () {
                // Navigate to next screen
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF9575CD),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          'Make an Impact',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCauseCard(String text, IconData icon) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Color(0xFF26A69A)),
          SizedBox(height: 5),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF26A69A)),
          ),
        ],
      ),
    );
  }
}