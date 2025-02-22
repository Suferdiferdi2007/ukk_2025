import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateUser extends StatefulWidget {
  final int UserID;

  const UpdateUser({super.key, required this.UserID});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final formKey = GlobalKey<FormState>();
  final user = TextEditingController();
  final pass = TextEditingController();
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    dataUser();
  }

  Future<void> dataUser() async {
    final data = await supabase
        .from('user')
        .select()
        .eq('UserID', widget.UserID)
        .single();

    setState(() {
      user.text = (data['Username'] ?? '').toString();
      pass.text = (data['Password'] ?? '').toString();
    });
  }

  Future<void> updatePelanggan() async {
    if (formKey.currentState!.validate()) {
      await supabase.from('user').update({
        'Username': user.text,
        'Password': pass.text,
      }).eq('UserID', widget.UserID.toString());

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
        title: const Text('Edit User',
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
              _textField(user, 'Username'),
              const SizedBox(height: 10),
              _textField(pass, 'Password'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: updatePelanggan,
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

  Widget _textField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: TextStyle(color: Color.fromARGB(255, 34, 1, 220)),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 34, 1, 220)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 34, 1, 220)),
        ),
      ),
      validator: (value) => value!.isEmpty ? '$label tidak boleh kosong' : null,
    );
  }
}