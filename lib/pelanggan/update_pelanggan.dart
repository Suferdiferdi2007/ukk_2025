import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdatePelanggan extends StatefulWidget {
  final int PelangganID;
  const UpdatePelanggan({super.key, required this.PelangganID});

  @override
  State<UpdatePelanggan> createState() => _UpdatePelangganState();
}

class _UpdatePelangganState extends State<UpdatePelanggan> {
  final formKey = GlobalKey<FormState>();
  final nmplg = TextEditingController();
  final alamat = TextEditingController();
  final notlp = TextEditingController();
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    dataPelanggan();
  }

  Future<void> dataPelanggan() async {
    final data = await supabase
        .from('pelanggan')
        .select()
        .eq('PelangganID', widget.PelangganID)
        .single();

    setState(() {
      nmplg.text = data['NamaPelanggan'] ?? '';
      alamat.text = data['Alamat'] ?? '';
      notlp.text = data['NomorTelepon']?.toString() ?? '';
    });
  }

  Future<void> updatePelanggan() async {
    if (formKey.currentState!.validate()) {
      await supabase.from('pelanggan').update({
        'NamaPelanggan': nmplg.text,
        'Alamat': alamat.text,
        'NomorTelepon': notlp.text,
      }).eq('PelangganID', widget.PelangganID);

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
        backgroundColor: const Color.fromARGB(255, 48, 119, 50),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _buildTextField(nmplg, 'Nama Pelanggan'),
              const SizedBox(height: 10),
              _buildTextField(alamat, 'Alamat'),
              const SizedBox(height: 10),
              _buildTextField(notlp, 'Nomor Telepon', isNumber: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updatePelanggan,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 48, 119, 50)),
                child:
                    const Text('Update', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      validator: (value) => value!.isEmpty ? '$label tidak boleh kosong' : null,
    );
  }
}