import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Order extends StatefulWidget {
  final Map<String, dynamic> produk;

  const Order({Key? key, required this.produk}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  final supabase = Supabase.instance.client;
  int jumlahProduk = 0;
  int? selectedPelangganID;
  List<Map<String, dynamic>> pelangganList = [];

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  void updateJumlahProduk(int delta) {
    setState(() {
      jumlahProduk = max(0, min(jumlahProduk + delta, widget.produk['Stok'] ?? 0));
    });
  }

  Future<void> fetchPelanggan() async {
    final data = await supabase.from('pelanggan').select();
    setState(() {
      pelangganList = List<Map<String, dynamic>>.from(data);
      if (pelangganList.isNotEmpty) {
        selectedPelangganID = pelangganList.first['PelangganID'];
      }
    });
  }

  Future<void> simpanPesanan() async {
    if (jumlahProduk == 0 || selectedPelangganID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih pelanggan dan jumlah produk harus lebih dari 0!')),
      );
      return;
    }
    
    try {
      final penjualan = await supabase.from('penjualan').insert({
        'PelangganID': selectedPelangganID,
        'TanggalPenjualan': DateTime.now().toIso8601String(),
        'TotalHarga': jumlahProduk * (widget.produk['Harga'] ?? 0),
      }).select('PenjualanID').single();

      await supabase.from('detailpenjualan').insert({
        'ProdukID': widget.produk['ProdukID'],
        'PenjualanID': penjualan['PenjualanID'],
        'JumlahProduk': jumlahProduk,
        'Subtotal': jumlahProduk * (widget.produk['Harga'] ?? 0),
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pesanan berhasil disimpan! Total: Rp${jumlahProduk * (widget.produk['Harga'] ?? 0)}')),
      );
      
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan pesanan!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;
    final totalHarga = jumlahProduk * (produk['Harga'] ?? 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 48, 119, 50),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 48, 119, 50)),
        child: Center(
          child: SizedBox(
            width: 300,
            height: 400,
            child: Card(
              margin: const EdgeInsets.all(20),
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(produk['NamaProduk'] ?? 'Nama Produk Tidak Tersedia',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Text('Harga: Rp${produk['Harga'] ?? 0}', style: const TextStyle(fontSize: 18)),
                    Text('Stok Tersedia: ${produk['Stok'] ?? 'Tidak Tersedia'}', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 16),
                    DropdownButton<int>(
                      value: selectedPelangganID,
                      hint: const Text('Pilih Pelanggan'),
                      borderRadius: BorderRadius.circular(12),
                      onChanged: (value) {
                        setState(() {
                          selectedPelangganID = value;
                        });
                      },
                      items: pelangganList.map((pelanggan) {
                        return DropdownMenuItem<int>(
                          value: pelanggan['PelangganID'],
                          child: Text(pelanggan['NamaPelanggan']),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: jumlahProduk > 0 ? () => updateJumlahProduk(-1) : null,
                          icon: const Icon(Icons.remove_circle, size: 32, color: Colors.red),
                        ),
                        Text('$jumlahProduk',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: () => updateJumlahProduk(1),
                          icon: const Icon(Icons.add_circle, size: 32, color: Colors.green),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: jumlahProduk > 0 ? simpanPesanan : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (jumlahProduk > 0) ? const Color.fromARGB(255, 48, 119, 50) : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text('Pesan (Rp$totalHarga)',
                          style: const TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}