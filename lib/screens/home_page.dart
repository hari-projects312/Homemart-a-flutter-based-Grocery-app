import 'package:flutter/material.dart';
import 'item_list_page.dart';
import '../items_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> groceries = [
    {'name': 'Fruits', 'image': 'images/fruits.jpg'},
    {'name': 'Vegetables', 'image': 'images/vegetables.webp'},
    {'name': 'Dairy', 'image': 'images/dairy.jpg'},
    {'name': 'Snacks', 'image': 'images/snacks.webp'},
    {'name': 'Beverages', 'image': 'images/beverages.jpg'},
    {'name': 'Grains', 'image': 'images/grains.webp'},
    {'name': 'Household Cares', 'image': 'images/household_cares.jpg'},
    {'name': 'Meat', 'image': 'images/meat.webp'},
    {'name': 'Staples', 'image': 'images/staples.webp'},
    {'name': 'Personal Care', 'image': 'images/personal_care.png'},
  ];

  List<Map<String, String>> _filteredGroceries = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _filteredGroceries = List.from(groceries);
    _searchController.addListener(_filterGroceries);
  }

  void _filterGroceries() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredGroceries = List.from(groceries);
      } else {
        _filteredGroceries = groceries.where((item) {
          final name = item['name']!.toLowerCase();
          return name.contains(query);
        }).toList();
      }
    });
  }

  void _submitSearch(String query) {
    final searchQuery = query.trim().toLowerCase();
    if (searchQuery.isEmpty) return;

    final List<Map<String, dynamic>> matchedItems = [];

    itemsData.forEach((category, items) {
      for (var item in items) {
        if (item['name'].toString().toLowerCase().contains(searchQuery)) {
          matchedItems.add(item);
        }
      }
    });

    if (matchedItems.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ItemListPage(category: 'Search Results', items: matchedItems),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No matching items found')));
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        title: const Text('HomeMart'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: _submitSearch,
              decoration: InputDecoration(
                hintText: 'Search your item here',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.mic, color: Colors.grey),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Expanded(
            child: _filteredGroceries.isEmpty
                ? const Center(child: Text('No items found'))
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _filteredGroceries.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 4,
                        ),
                    itemBuilder: (context, index) {
                      final item = _filteredGroceries[index];
                      final category = item['name']!;
                      final image = item['image']!;

                      return InkWell(
                        onTap: () {
                          final categoryItems = itemsData[category] ?? [];

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ItemListPage(
                                category: category,
                                items: categoryItems,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 3,
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  category,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}
