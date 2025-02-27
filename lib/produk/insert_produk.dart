import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertProduk extends StatefulWidget {
  const InsertProduk({super.key});

  @override
  State<InsertProduk> createState() => _InsertProdukState();
}

class _InsertProdukState extends State<InsertProduk> {
  final formKey = GlobalKey<FormState>();
  final nama = TextEditingController();
  final harga = TextEditingController();
  final stok = TextEditingController();
  final supabase = Supabase.instance.client;

  Future<void> simpan() async {
    if (formKey.currentState!.validate()) {
      try {
        // Cek apakah NamaProduk sudah ada di database
        final cekProduk = await supabase
            .from('produk')
            .select('NamaProduk')
            .eq('NamaProduk', nama.text)
            .maybeSingle();

        if (cekProduk != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk sudah ada, tidak boleh duplikat!')),
          );
          return;
        }

        // Simpan data ke database dengan konversi harga & stok ke integer
        await supabase.from('produk').insert({
          'NamaProduk': nama.text,
          'Harga': int.tryParse(harga.text) ?? 0,
          'Stok': int.tryParse(stok.text) ?? 0,
        });

        // Tampilkan pesan sukses dan navigasi ke HomePage
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tambah Produk', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 34, 1, 220), // Coklat tua untuk kesan elegan
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 34, 1, 220), Color.fromARGB(255, 34, 1, 220)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _textField(nama, 'Nama Produk'),
                const SizedBox(height: 10),
                _textField(harga, 'Harga', isNumber: true),
                const SizedBox(height: 10),
                _textField(stok, 'Stok', isNumber: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: simpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 34, 1, 220), // Coklat kopi
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget untuk Input Field
Widget _textField(TextEditingController controller, String label, {bool isNumber = false}) {
  return TextFormField(
    controller: controller,
    keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color.fromARGB(255, 34, 1, 220)), // Warna label coklat gelap
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color.fromARGB(255, 34, 1, 220)), // Outline warna coklat
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color.fromARGB(255, 34, 1, 220)), // Warna lebih gelap saat fokus
      ),
      filled: true,
      fillColor: Colors.white, // Background input tetap putih agar kontras
    ),
    validator: (value) =>
        (value == null || value.isEmpty) ? '$label tidak boleh kosong' : null,
  );
}
