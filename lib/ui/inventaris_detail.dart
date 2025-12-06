import 'package:flutter/material.dart';
import 'package:goonmarket/bloc/inventaris_bloc.dart';
import 'package:goonmarket/model/inventaris.dart';
import 'package:goonmarket/ui/inventaris_form.dart';
import 'package:goonmarket/ui/inventaris_page.dart';
import 'package:goonmarket/widget/warning_dialog.dart';
// ignore: must_be_immutable
class InventarisDetail extends StatefulWidget {
  Inventaris? inventaris;
  InventarisDetail({super.key, this.inventaris});

  @override
  _InventarisDetailState createState() => _InventarisDetailState();
}

class _InventarisDetailState extends State<InventarisDetail> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Inventaris GoonMarket'),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2E7D32).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildDetailCard(),
                const SizedBox(height: 32),
                _tombolHapusEdit()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E7D32).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.inventory_2,
            color: Colors.white,
            size: 60,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.inventaris!.nama ?? 'Nama tidak tersedia',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border(
            left: BorderSide(
              color: const Color(0xFF2E7D32),
              width: 5,
            ),
          ),
        ),
        child: Column(
          children: [
            _detailItem(
              icon: Icons.attach_money,
              label: 'Harga',
              value: 'Rp ${_formatCurrency(widget.inventaris!.harga.toString())}',
            ),
            const SizedBox(height: 16),
            _detailItem(
              icon: Icons.storage,
              label: 'Jumlah Stok',
              value: '${widget.inventaris!.jumlah} unit',
            ),
            const SizedBox(height: 16),
            _detailItem(
              icon: Icons.calendar_today,
              label: 'Tanggal Masuk',
              value: widget.inventaris!.tanggalMasuk.toString(),
            ),
            const SizedBox(height: 16),
            _detailItem(
              icon: Icons.warning,
              label: 'Tanggal Kedaluwarsa',
              value: widget.inventaris!.tanggalKedaluwarsa.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF2E7D32),
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatCurrency(String value) {
    try {
      int num = int.parse(value);
      return num.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => '.',
      );
    } catch (e) {
      return value;
    }
  }
  
  Widget _tombolHapusEdit() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.edit),
            label: const Text(
              "EDIT",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InventarisForm(
                    inventaris: widget.inventaris!,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.delete),
            label: const Text(
              "HAPUS",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => confirmHapus(),
          ),
        ),
      ],
    );
  }
  
  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        "Konfirmasi Hapus",
        style: TextStyle(
          color: Color(0xFF2E7D32),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        TextButton(
          child: const Text(
            "Batal",
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[600],
          ),
          child: const Text("Ya, Hapus"),
          onPressed: () {
            Navigator.pop(context);
            InventarisBloc.deleteInventaris(
              id: int.parse(widget.inventaris!.id!),
            ).then((value) => {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const InventarisPage(),
                ),
                (route) => false,
              )
            }, onError: (error) {
              showDialog(
                context: context,
                builder: (BuildContext context) => const WarningDialog(
                  description: "Hapus gagal, silahkan coba lagi",
                ),
              );
            });
          },
        ),
      ],
    );
    showDialog(builder: (context) => alertDialog, context: context);
  }
}