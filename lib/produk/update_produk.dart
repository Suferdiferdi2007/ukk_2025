import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateProduk extends StatefulWidget {
  final int ProdukID;
  const UpdateProduk({super.key, required this.ProdukID});

  @override
  State<UpdateProduk> createState() => _UpdateProdukState();
}

class _UpdateProdukState extends State<UpdateProduk> {
  final formKey = GlobalKey<FormState>();
  final nama = TextEditingController();
  final harga = TextEditingController();
  final stok = TextEditingController();
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    dataProduk();
  }

  Future<void> dataProduk() async {
    final data = await supabase
        .from('produk')
        .select()
        .eq('ProdukID', widget.ProdukID)
        .single();

    setState(() {
      nama.text = data['NamaProduk'] ?? '';
      harga.text = data['Harga']?.toString() ?? '';
      stok.text = data['Stok']?.toString() ?? '';
    });
  }

  Future<void> updateProduk() async {
    if (formKey.currentState!.validate()) {
      await supabase.from('produk').update({
        'NamaProduk': nama.text,
        'Harga': double.tryParse(harga.text),
        'Stok': int.tryParse(stok.text),
      }).eq('ProdukID', widget.ProdukID);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diperbarui!')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pelanggan',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 34, 1, 220),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
                onPressed: updateProduk,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 34, 1, 220)),
                child:
                    const Text('Update', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),)
    );
  }

  Widget _textField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: label == 'Password'
            ? IconButton(
                icon: Icon(
                  Icons.visibility,
                  color: Color.fromARGB(255, 34, 1, 220),
                ),
                onPressed: () {},
              )
            : null,
      ),
      validator: (value) => value!.isEmpty ? '$label tidak boleh kosong' : null,
    );
  }
}
