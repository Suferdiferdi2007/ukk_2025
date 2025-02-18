import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Penjualan'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Logic untuk logout
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Ringkasan Penjualan
            Card(
              color: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text('Total Penjualan', style: TextStyle(color: Colors.white, fontSize: 18)),
                    SizedBox(height: 10),
                    Text('Rp 5.000.000', style: TextStyle(color: Colors.white, fontSize: 24)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            
            // Daftar Produk
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Misalnya jumlah produk
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text('Produk ${index + 1}'),
                      subtitle: Text('Stok: 10 | Harga: Rp 1.000.000'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Logic untuk mengedit produk
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            
            // Button Aksi Cepat
            ElevatedButton(
              onPressed: () {
                // Logic untuk tambah penjualan
              },
              child: Text('Tambah Penjualan'),
            ),
          ],
        ),
      ),
    );
  }
}
