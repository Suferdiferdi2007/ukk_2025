import 'package:flutter/material.dart';
import 'package:flutter_application_1/penjualan/struk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class IndexPenjualan extends StatefulWidget {
  const IndexPenjualan({super.key});

  @override
  State<IndexPenjualan> createState() => _IndexPenjualanState();
}

class _IndexPenjualanState extends State<IndexPenjualan> {
  final supabase = Supabase.instance.client;
  final TextEditingController cari = TextEditingController();
  List<bool> dipilihItem = [];
  List<Map<String, dynamic>> penjualanList = [];
  List<Map<String, dynamic>> mencariPenjualan = [];

  @override
  void initState() {
    super.initState();
    ambilPenjualan();
    cari.addListener(pencarianPenjualan);
  }

  Future<void> ambilPenjualan() async {
    try {
      final data = await supabase
          .from('penjualan')
          .select('PenjualanID, TanggalPenjualan, TotalHarga, pelanggan(NamaPelanggan)')
          .order('TanggalPenjualan', ascending: false);

      setState(() {
        penjualanList = List<Map<String, dynamic>>.from(data);
        dipilihItem = List.generate(penjualanList.length, (_) => false);
        mencariPenjualan = penjualanList;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void pencarianPenjualan() {
    setState(() {
      mencariPenjualan = penjualanList.where((penjualan) {
        final namaPelanggan = penjualan['pelanggan']?['NamaPelanggan'] ?? '';
        final penjualanID = penjualan['PenjualanID'].toString();

        return namaPelanggan.toLowerCase().contains(cari.text.toLowerCase()) ||
            penjualanID.contains(cari.text);
      }).toList();
    });
  }

  Future<void> hapusPenjualan(int id) async {
    await supabase.from('penjualan').delete().eq('PenjualanID', id);
    ambilPenjualan();
  }

  void konfirmasiHapus(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Penjualan'),
        content: const Text('Apakah Anda yakin ingin menghapus penjualan ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          TextButton(
            onPressed: () {
              hapusPenjualan(id);
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
                labelText: "Cari Penjualan...",
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 34, 1, 220)),
                prefixIcon: const Icon(Icons.search,
                    color: Color.fromARGB(255, 34, 1, 220)),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: mencariPenjualan.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak Ada Data Penjualan',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 34, 1, 220)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: mencariPenjualan.length,
                    itemBuilder: (context, index) {
                      final pen = mencariPenjualan[index];
                      final namaPelanggan =
                          pen['pelanggan']?['NamaPelanggan'] ?? 'Tidak tersedia';

                      return Card(
                        color: Color.fromARGB(255, 34, 1, 220),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Checkbox(
                                value: dipilihItem[index],
                                activeColor: Colors.white,
                                checkColor: Color.fromARGB(255, 34, 1, 220),
                                side: const BorderSide(color: Colors.white, width: 2),
                                onChanged: (bool? value) {
                                  setState(() {
                                    dipilihItem[index] = value ?? false;
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Tanggal: ${pen['TanggalPenjualan'] ?? 'Tidak tersedia'}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    Text(
                                        'Total Harga: ${pen['TotalHarga'] != null ? pen['TotalHarga'].toString() : 0}',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                    Text(
                                        'Nama Pelanggan: $namaPelanggan',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (dipilihItem.contains(true))
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  final selectedPenjualan = <Map<String, dynamic>>[];

                  for (int i = 0; i < penjualanList.length; i++) {
                    if (dipilihItem[i]) {
                      selectedPenjualan.add(penjualanList[i]);
                    }
                  }

                  if (selectedPenjualan.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Struk(
                          selectedPenjualan: selectedPenjualan,
                          tanggalPesanan:
                              DateFormat('yyyy-MM-dd').format(DateTime.now()),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Tidak ada penjualan yang dipilih')));
                  }
                },
                child: const Text('Checkout',
                    style: TextStyle(
                        fontSize: 18, color: Color.fromARGB(255, 34, 1, 220))),
              ),
            ),
        ],
      ),
    );
  }
}
