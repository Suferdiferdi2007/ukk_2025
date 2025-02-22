import 'package:flutter/material.dart';
import 'package:flutter_application_1/produk/insert_produk.dart';
import 'package:flutter_application_1/produk/order.dart';
import 'package:flutter_application_1/produk/update_produk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IndexProduk extends StatefulWidget {
  const IndexProduk({super.key});

  @override
  State<IndexProduk> createState() => _IndexProdukState();
}

class _IndexProdukState extends State<IndexProduk> {
  final supabase = Supabase.instance.client;
  final TextEditingController cariController = TextEditingController();
  List<Map<String, dynamic>> produkList = [], mencariProduk = [];

  @override
  void initState() {
    super.initState();
    fetchProduk();
    cariController.addListener(filterProduk);
  }

  Future<void> fetchProduk() async {
    try {
      final data = await supabase.from('produk').select();
      setState(() {
        produkList = List<Map<String, dynamic>>.from(data);
        mencariProduk = List.from(produkList);
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  void filterProduk() {
    setState(() {
      mencariProduk = produkList
          .where((produk) => produk['NamaProduk']
              .toString()
              .toLowerCase()
              .contains(cariController.text.toLowerCase()))
          .toList();
    });
  }

  Future<void> hapusProduk(int id) async {
    await supabase.from('produk').delete().eq('ProdukID', id);
    fetchProduk();
  }

  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          TextButton(
            onPressed: () {
              hapusProduk(id);
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: cariController,
              decoration: InputDecoration(
                labelText: "Cari Produk...",
                labelStyle: const TextStyle(color: Colors.brown),
                prefixIcon: const Icon(Icons.search, color: Colors.brown),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: mencariProduk.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak Ada Data Produk',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: mencariProduk.length,
                    itemBuilder: (context, index) {
                      final p = mencariProduk[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Order(produk: p))),
                        child: Card(
                          color: Colors.brown,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(p['NamaProduk'] ?? 'Produk tidak tersedia',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Harga: Rp ${p['Harga'] != null ? double.parse(p['Harga'].toString()).toStringAsFixed(2) : 'Tidak tersedia'}",
                                    style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white)),
                                Text("Stok: ${p['Stok']?.toString() ?? 'Tidak tersedia'}",
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProduk(ProdukID: p['ProdukID'] ?? 0))),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => confirmDelete(p['ProdukID']),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InsertProduk())),
        backgroundColor: Colors.brown,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    cariController.dispose();
    super.dispose();
  }
}