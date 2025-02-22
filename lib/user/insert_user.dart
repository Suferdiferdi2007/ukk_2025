import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertUser extends StatefulWidget {
  const InsertUser({super.key});

  @override
  State<InsertUser> createState() => _InsertUserState();
}

class _InsertUserState extends State<InsertUser> {
  final formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final pass = TextEditingController();
  final supabase = Supabase.instance.client;

  Future<void> simpan() async {
    if (formKey.currentState!.validate()) {
      final simpanData = await supabase
          .from('user')
          .select('Username')
          .eq('Username', username.text)
          .maybeSingle();

      if (simpanData != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak boleh ada data ganda!')),
        );
        return;
      }

      await supabase.from('user').insert({
        'Username': username.text,
        'Password': pass.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan')));

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
        title: const Text('Tambah User', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade200, Colors.brown.shade100],
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
              _textField(username, 'Username'),
              const SizedBox(height: 10),
              _textField(pass, 'Password', isNumber: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Simpan', style: TextStyle(color: Colors.white)),
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
  return TextFormField(
    controller: controller,
    keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.brown),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    ),
    validator: (value) =>
        (value == null || value.isEmpty) ? '$label tidak boleh kosong' : null,
  );
}