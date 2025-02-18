import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp());
}

class MaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(), // Halaman Dashboard
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Penjualan
            Card(
              margin: EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(Icons.shopping_cart, color: Colors.blue),
                title: Text("Penjualan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text("Lihat data penjualan terbaru"),
                onTap: () {
                  // Aksi navigasi ke halaman Penjualan
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SalesScreen()),
                  );
                },
              ),
            ),

            // Bagian Pelanggan
            Card(
              margin: EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(Icons.people, color: Colors.green),
                title: Text("Pelanggan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text("Lihat data pelanggan"),
                onTap: () {
                  // Aksi navigasi ke halaman Pelanggan
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomerScreen()),
                  );
                },
              ),
            ),

            // Bagian Produk
            Card(
              margin: EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(Icons.inventory, color: Colors.orange),
                title: Text("Produk", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text("Lihat daftar produk"),
                onTap: () {
                  // Aksi navigasi ke halaman Produk
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductScreen()),
                  );
                },
              ),
            ),

            // Bagian Detail Penjualan
            Card(
              margin: EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(Icons.report, color: Colors.red),
                title: Text("Detail Penjualan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text("Lihat laporan detail penjualan"),
                onTap: () {
                  // Aksi navigasi ke halaman Detail Penjualan
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SalesDetailScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman Penjualan
class SalesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Penjualan")),
      body: Center(child: Text("Data Penjualan akan ditampilkan di sini")),
    );
  }
}

// Halaman Pelanggan
class CustomerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pelanggan")),
      body: Center(child: Text("Data Pelanggan akan ditampilkan di sini")),
    );
  }
}

// Halaman Produk
class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Produk")),
      body: Center(child: Text("Data Produk akan ditampilkan di sini")),
    );
  }
}

// Halaman Detail Penjualan
class SalesDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Penjualan")),
      body: Center(child: Text("Laporan Detail Penjualan akan ditampilkan di sini")),
    );
  }
}

