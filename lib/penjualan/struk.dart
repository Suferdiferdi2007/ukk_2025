import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Struk extends StatelessWidget {
  final List<Map<String, dynamic>> selectedPenjualan;
  final String tanggalPesanan;

  const Struk({
    super.key,
    required this.selectedPenjualan,
    required this.tanggalPesanan,
  });

  int _hitungTotalHarga() {
    return selectedPenjualan.fold(0, (sum, item) => sum + (item['TotalHarga'] as int));
  }

  Future<void> _cetakStruk() async {
    final pdf = pw.Document();
    int totalHarga = _hitungTotalHarga();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                'Toko Buah',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text(
                'Struk Pembelian',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Tanggal:', style: pw.TextStyle(fontSize: 12)),
                pw.Text(tanggalPesanan, style: pw.TextStyle(fontSize: 12)),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Text('Rincian Pesanan:', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FlexColumnWidth(3),
                1: pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('Nama Pelanggan', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Total Harga', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                ...selectedPenjualan.map((penjualan) {
                  String namaPelanggan = penjualan['pelanggan']?['NamaPelanggan'] ?? 'Tidak tersedia';
                  return pw.TableRow(
                    children: [
                      pw.Text(namaPelanggan, style: pw.TextStyle(fontSize: 12)),
                      pw.Text('Rp ${penjualan['TotalHarga']}', style: pw.TextStyle(fontSize: 12)),
                    ],
                  );
                }).toList(),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total Harga:', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Text('Rp $totalHarga', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text(
                'Terima kasih atas pembelian Anda!',
                style: pw.TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Toko Buah.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalHarga = _hitungTotalHarga();

    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        'Struk Pembelian',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Text(
                  'Toko Buah',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Divider(),
            Text(
              'Tanggal Pesanan: $tanggalPesanan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            const Text(
              'Rincian Harga:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: selectedPenjualan.map((penjualan) {
                String namaPelanggan = penjualan['pelanggan']?['NamaPelanggan'] ?? 'Tidak tersedia';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Nama: $namaPelanggan'),
                      Text('Rp ${penjualan['TotalHarga']}'),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Harga:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp $totalHarga',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Text(
                  'Terima kasih atas pembelian Anda!',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tutup', style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
          onPressed: _cetakStruk,
          child: const Text('Cetak Struk', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}