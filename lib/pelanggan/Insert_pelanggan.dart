import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertPelanggan extends StatefulWidget {
  const InsertPelanggan({super.key});

  @override
  State<InsertPelanggan> createState() => _InsertPelangganState();
}

class _InsertPelangganState extends State<InsertPelanggan> {
  final formKey = GlobalKey<FormState>();
  final nama = TextEditingController();
  final alamat = TextEditingController();
  final ntlp = TextEditingController();
  final supabase = Supabase.instance.client;

  Future<void> simpan() async {
    if (formKey.currentState!.validate()) {
      // final simpan = await supabase
      //     .from('pelanggan')
      //     .select('NamaPelanggan')
      //     .eq('NamaPelanggan', nama.text)
      //     .maybeSingle();

      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Data berhasil disimpan')));

      // if (simpan != null) {
      //   // Untuk menampilkan pesan error jika data sudah ada
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Tidak boleh ada data ganda!')),
      //   );
      //   return;
      // }

      // Untuk menyimpan data jika data belum ada
      await supabase.from('pelanggan').insert({
        'NamaPelanggan': nama.text,
        'Alamat': alamat.text,
        'NomorTelepon': ntlp.text,
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
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
        title: const Text('Tambah Pelanggan',
            style: TextStyle(color: Colors.white)),
        backgroundColor:  Color.fromARGB(255, 34, 1, 220),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 87, 67, 199), Color.fromARGB(255, 105, 88, 205)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
     child:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _textField(nama, 'Nama Pelanggan'),
              const SizedBox(height: 10),
              _textField(alamat, 'Alamat'),
              const SizedBox(height: 10),
              _textField(ntlp, 'Nomor Telepon',
                  isNumber:
                      true), // isNumber: true = Input hanya akan menerima angka
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: simpan,
                style: ElevatedButton.styleFrom(
                    backgroundColor:  Color.fromARGB(255, 34, 1, 220)),
                child:
                    const Text('Simpan', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),)
    );
  }
}

Widget _textField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    // {bool isNumber = false} = Input akan menerima teks biasa
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber
          ? [FilteringTextInputFormatter.digitsOnly]
          : [], // [FilteringTextInputFormatter.digitsOnly] = Mencegah pengguna mengetik huruf atau simbol
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: label.toLowerCase().contains("password")
            ? Icon(Icons.visibility, color: Color.fromARGB(255, 34, 1, 220))
            : null,
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? '$label tidak boleh kosong' : null,
    );
  }
