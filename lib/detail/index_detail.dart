import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IndexDetail extends StatefulWidget {
  const IndexDetail({super.key});

  @override
  State<IndexDetail> createState() => _IndexDetailState();
}

class _IndexDetailState extends State<IndexDetail> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController cariController = TextEditingController();
  List<Map<String, dynamic>> detailList = [];
  List<Map<String, dynamic>> filteredDetailList = [];

  @override
  void initState() {
    super.initState();
    fetchDetail();
    cariController.addListener(searchDetail);
  }

  Future<void> fetchDetail() async {
  try {
    final data = await supabase
        .from('detailpenjualan')
        .select('*, penjualan(pelanggan(NamaPelanggan)), produk(NamaProduk)');
    setState(() {
      detailList = List<Map<String, dynamic>>.from(data);
      filteredDetailList = detailList;
    });
  } catch (e) {
    debugPrint('Error fetching details: $e');
  }
}


  void searchDetail() {
  setState(() {
    filteredDetailList = detailList.where((detail) {
      final namaPelanggan =
          detail['penjualan']?['pelanggan']?['NamaPelanggan'] ?? ''; // Cegah null
      final penjualanID = detail['PenjualanID'].toString(); 

      return namaPelanggan.toLowerCase().contains(cariController.text.toLowerCase()) ||
             penjualanID.contains(cariController.text);
    }).toList();
  });
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
                labelText: "Cari Detail...",
                labelStyle: const TextStyle(color: Color.fromARGB(255, 48, 119, 50)),
                prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 48, 119, 50)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: filteredDetailList.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak Ada Data Detail',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 48, 119, 50),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredDetailList.length,
                    itemBuilder: (context, index) {
                      final detail = filteredDetailList[index];
                      return Card(
                        color: const Color.fromARGB(255, 48, 119, 50),
                        elevation: 2, // Mengurangi shadow agar lebih kecil
                        margin: const EdgeInsets.symmetric(vertical: 4), // Mengurangi jarak antar card
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Card lebih kecil
                        child: Padding(
                          padding: const EdgeInsets.all(10), // Mengurangi padding dalam card
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detail ID: ${detail['DetailID']?.toString() ?? 'tidak tersedia'}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 5),
                              Wrap(
                                spacing: 10,
                                runSpacing: 5,
                                children: [
                                  _buildDetailItem("Nama Pelanggan", detail['penjualan']?['pelanggan']?['NamaPelanggan']),
                                  _buildDetailItem("Produk", detail['produk']?['NamaProduk']),
                                  _buildDetailItem("Jumlah Produk", detail['JumlahProduk']),
                                  _buildDetailItem("Total", detail['Subtotal']),
                                ],
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
    );
  }

  Widget _buildDetailItem(String label, dynamic value) {
    return Text(
      "$label: ${value?.toString() ?? 'tidak tersedia'}",
      style: const TextStyle(fontSize: 14, color: Colors.white),
    );
  }

  @override
  void dispose() {
    cariController.dispose();
    super.dispose();
  }
}
