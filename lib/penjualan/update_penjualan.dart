import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class UpdatePenjualan extends StatefulWidget {
  final int PenjualanID;
  const UpdatePenjualan({super.key, required this.PenjualanID});

  @override
  State<UpdatePenjualan> createState() => _UpdatePenjualanState();
}

class _UpdatePenjualanState extends State<UpdatePenjualan> {
  final formKey = GlobalKey<FormState>();
  final totalHarga = TextEditingController();
  final tanggalPenjualan = TextEditingController();
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> pelangganList = [];
  int? selectedPelangganID;

  @override
  void initState() {
    super.initState();
    dataPenjualan();
    ambilPelanggan();
  }

  Future<void> dataPenjualan() async {
    try {
      final data = await supabase
          .from('penjualan')
          .select()
          .eq('PenjualanID', widget.PenjualanID)
          .maybeSingle();

      if (data != null) {
        setState(() {
          totalHarga.text = data['TotalHarga']?.toString() ?? '';
          tanggalPenjualan.text = data['TanggalPenjualan'] ?? '';
          selectedPelangganID = data['PelangganID'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data penjualan: $e')),
      );
    }
  }

  Future<void> ambilPelanggan() async {
    try {
      final data = await supabase.from('pelanggan').select('PelangganID, NamaPelanggan');
      setState(() {
        pelangganList = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data pelanggan: $e')),
      );
    }
  }

  Future<void> updatePenjualan() async {
    if (formKey.currentState!.validate() && selectedPelangganID != null) {
      try {
        await supabase.from('penjualan').update({
          'TotalHarga': int.parse(totalHarga.text),
          'TanggalPenjualan': tanggalPenjualan.text,
          'PelangganID': selectedPelangganID,
        }).eq('PenjualanID', widget.PenjualanID);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data penjualan berhasil diperbarui!')),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data: $e')),
        );
      }
    }
  }

  Future<void> pilihTanggal(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        tanggalPenjualan.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Penjualan',
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
              _buildTextField(totalHarga, 'Total Harga', isNumber: true),
              const SizedBox(height: 10),
              
              // **DatePicker untuk Tanggal Penjualan**
              TextFormField(
                controller: tanggalPenjualan,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal Penjualan',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => pilihTanggal(context),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Tanggal tidak boleh kosong' : null,
              ),
              const SizedBox(height: 10),

              // **Dropdown untuk memilih pelanggan**
              DropdownButtonFormField<int>(
                value: selectedPelangganID,
                items: pelangganList.map((pelanggan) {
                  return DropdownMenuItem<int>(
                    value: pelanggan['PelangganID'],
                    child: Text(pelanggan['NamaPelanggan']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPelangganID = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Pilih Pelanggan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null ? 'Pelanggan harus dipilih' : null,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: updatePenjualan,
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
