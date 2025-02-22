import 'package:flutter/material.dart';
import 'package:flutter_application_1/detail/index_detail.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/pelanggan/index_pelanggan.dart';
import 'package:flutter_application_1/penjualan/index_penjualan.dart';
import 'package:flutter_application_1/produk/index_produk.dart';
import 'package:flutter_application_1/user/index_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const IndexDetail(),
    const IndexPenjualan(),
    const IndexProduk(),
    const IndexPelanggan(),
  ];

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Bubblelicious Cafe',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.brown.shade800),
              child: ListTile(
                leading: const Icon(Icons.arrow_back_ios, color: Colors.white),
                title: const Text(
                  'Pengaturan',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
            ListTile(
              leading: Icon(Icons.people, color: Colors.brown.shade800),
              title: Text('User', style: TextStyle(color: Colors.brown.shade800)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IndexUser()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.brown.shade800),
              title: Text('Logout', style: TextStyle(color: Colors.brown.shade800)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.brown.shade800,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Detail Penjualan'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Penjualan'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt), label: 'Pelanggan'),
        ],
      ),
    );
  }
}
