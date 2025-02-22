import 'package:flutter/material.dart';
import 'package:flutter_application_1/pelanggan/Insert_pelanggan.dart';
import 'package:flutter_application_1/pelanggan/update_pelanggan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IndexPelanggan extends StatefulWidget {
  const IndexPelanggan({super.key});

  @override
  State<IndexPelanggan> createState() => _IndexPelangganState();
}

class _IndexPelangganState extends State<IndexPelanggan> {
  final supabase = Supabase.instance.client;
  final TextEditingController cari = TextEditingController();
  List<Map<String, dynamic>> pelangganList = [];
  List<Map<String, dynamic>> mencariPelanggan = [];

  @override
  void initState() {
    super.initState();
    ambilPelanggan();
    cari.addListener(pencarianPelanggan);
  }

  Future<void> ambilPelanggan() async {
    try {
      final data = await supabase.from('pelanggan').select();
      setState(() {
        pelangganList = List<Map<String, dynamic>>.from(data);
        mencariPelanggan = pelangganList;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void pencarianPelanggan() {
    setState(() {
      mencariPelanggan = pelangganList
          .where((pelanggan) => pelanggan['NamaPelanggan']
              .toLowerCase()
              .contains(cari.text.toLowerCase()))
          .toList();
    });
  }

  Future<void> hapusPelanggan(int id) async {
    await supabase.from('pelanggan').delete().eq('PelangganID', id);
    ambilPelanggan();
  }

  void konfirmasiHapus(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pelanggan'),
        content: const Text('Apakah Anda yakin ingin menghapus pelanggan ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          TextButton(
            onPressed: () {
              hapusPelanggan(id);
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
              controller: cari,
              decoration: InputDecoration(
                labelText: "Cari Pelanggan...",
                labelStyle: const TextStyle(color: Color.fromARGB(255, 34, 1, 220)),
                prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 34, 1, 220)),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: mencariPelanggan.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak Ada Data Pelanggan',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 34, 1, 220)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: mencariPelanggan.length,
                    itemBuilder: (context, index) {
                      final p = mencariPelanggan[index];
                      return Card(
                        color: Color.fromARGB(255, 34, 1, 220),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(
                              p['NamaPelanggan'] ?? 'Pelanggan tidak tersedia',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p['Alamat'] ?? 'Alamat Tidak tersedia',
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white)),
                              Text(p['NomorTelepon'] ?? 'Tidak tersedia',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Color.fromARGB(255, 18, 158, 0)),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdatePelanggan(
                                          PelangganID: p['PelangganID'] ?? 0)),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    konfirmasiHapus(p['PelangganID']),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const InsertPelanggan())),
        backgroundColor: Color.fromARGB(255, 34, 1, 220),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    cari.dispose();
    super.dispose();
  }
}