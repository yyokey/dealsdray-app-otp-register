import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png', // Ensure this path is correct
              height: 40,
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search here',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.notifications, color: Colors.black),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner/Carousel Section
            Container(
              height: 150,
              color: Colors.grey[200],
              child: PageView(
                children: const [
                  Image(
                    image: AssetImage('assets/p1.jpg'),
                    width: 150,
                    height: 150, // Placeholder image
                    fit: BoxFit.cover,
                  ),
                  Image(
                    image: AssetImage('assets/p2.jpg'),
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // KYC Notification Section
            Container(
              padding: const EdgeInsets.all(15),
              color: Colors.blue[100],
              child: Column(
                children: [
                  const Text(
                    'KYC Pending',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'You need to provide the required documents for your account activation.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Handle button press
                    },
                    child: const Text('Click Here'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Category Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryIcon(Icons.smartphone, 'Mobile'),
                _buildCategoryIcon(Icons.laptop, 'Laptop'),
                _buildCategoryIcon(Icons.camera_alt, 'Camera'),
                _buildCategoryIcon(Icons.tv, 'LED'),
              ],
            ),
            const SizedBox(height: 20),

            // Exclusive Offers Section
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text(
                    'EXCLUSIVE FOR YOU',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildExclusiveOffer('assets/p1.jpg', '32% off'),
                        _buildExclusiveOffer('assets/p2.jpg', '14% off'),
                        _buildExclusiveOffer('assets/p3.jpg', '20% off'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Chat Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle chat button press
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.chat),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Deals'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0, // Default index
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Handle navigation logic here
        },
      ),
    );
  }

  // Helper widget for Category Icons
  Widget _buildCategoryIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }

  // Helper widget for Exclusive Offers
  Widget _buildExclusiveOffer(String imageUrl, String discount) {
    return Container(
      width: 150,
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Image.asset(imageUrl, width: 100, height: 100, fit: BoxFit.cover),
          const SizedBox(height: 5),
          Text(discount, style: const TextStyle(color: Colors.green)),
        ],
      ),
    );
  }
}
