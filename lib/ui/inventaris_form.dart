import 'package:flutter/material.dart';
import 'package:goonmarket/bloc/inventaris_bloc.dart';
import 'package:goonmarket/model/inventaris.dart';
import 'package:goonmarket/ui/inventaris_page.dart';
import 'package:goonmarket/widget/warning_dialog.dart';
// ignore: must_be_immutable
class InventarisForm extends StatefulWidget {
  Inventaris? inventaris;
  InventarisForm({super.key, this.inventaris});
  
  @override
  _InventarisFormState createState() => _InventarisFormState();
}

class _InventarisFormState extends State<InventarisForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH INVENTARIS GOONMARKET";
  String tombolSubmit = "SIMPAN";
  final _namaTextboxController = TextEditingController();
  final _hargaTextboxController = TextEditingController();
  final _jumlahTextboxController = TextEditingController();
  final _tanggalMasukTextboxController = TextEditingController();
  final _tanggalKedaluwarsaTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }
  
  isUpdate() {
    if (widget.inventaris != null) {
      setState(() {
        judul = "UBAH INVENTARIS GOONMARKET";
        tombolSubmit = "UBAH";
        _namaTextboxController.text = widget.inventaris!.nama!;
        _hargaTextboxController.text = widget.inventaris!.harga.toString();
        _jumlahTextboxController.text = widget.inventaris!.jumlah.toString();
        _tanggalMasukTextboxController.text = widget.inventaris!.tanggalMasuk!;
        _tanggalKedaluwarsaTextboxController.text = widget.inventaris!.tanggalKedaluwarsa!;
      });
    } else {
      judul = "TAMBAH INVENTARIS GOONMARKET";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _namaTextField(),
                  const SizedBox(height: 16),
                  _hargaTextField(),
                  const SizedBox(height: 16),
                  _jumlahTextField(),
                  const SizedBox(height: 16),
                  _tanggalMasukTextField(),
                  const SizedBox(height: 16),
                  _tanggalKedaluwarsaTextField(),
                  const SizedBox(height: 32),
                  _buttonSubmit()
                ],
              ),
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.add_box,
            color: Colors.white,
            size: 48,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          judul,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }
  //Membuat Textbox Nama Inventaris
  Widget _namaTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Nama Inventaris",
        labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
        prefixIcon: const Icon(Icons.shopping_bag, color: Color(0xFF2E7D32)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama Inventaris harus diisi";
        }
        return null;
      },
    );
  }
  //Membuat Textbox Harga Inventaris
  Widget _hargaTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Harga",
        labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
        prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF2E7D32)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
      ),
      keyboardType: TextInputType.number,
      controller: _hargaTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Harga harus diisi";
        }
        return null;
      },
    );
  }
  //Membuat Textbox Jumlah Inventaris
  Widget _jumlahTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Jumlah",
        labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
        prefixIcon: const Icon(Icons.storage, color: Color(0xFF2E7D32)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
      ),
      keyboardType: TextInputType.number,
      controller: _jumlahTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Jumlah harus diisi";
        }
        return null;
      },
    );
  }
  //Membuat Textbox Tanggal Masuk Inventaris
  Widget _tanggalMasukTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Tanggal Masuk (YYYY-MM-DD)",
        labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
        prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF2E7D32)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _tanggalMasukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Tanggal Masuk harus diisi";
        }
        return null;
      },
    );
  }
  //Membuat Textbox Tanggal Kedaluwarsa
  Widget _tanggalKedaluwarsaTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Tanggal Kedaluwarsa (YYYY-MM-DD)",
        labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
        prefixIcon: const Icon(Icons.warning, color: Color(0xFF2E7D32)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _tanggalKedaluwarsaTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Tanggal Kedaluwarsa harus diisi";
        }
        return null;
      },
    );
  }
  //Membuat Tombol Simpan/Ubah
  Widget _buttonSubmit() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                tombolSubmit,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) {
              if (widget.inventaris != null) {
                ubah();
              } else {
                simpan();
              }
            }
          }
        },
      ),
    );
  }

  simpan() {
    setState(() { 
      _isLoading = true; 
    }); 
    Inventaris createInventaris = Inventaris(id: null); 
    createInventaris.nama = _namaTextboxController.text; 
    createInventaris.harga = int.parse(_hargaTextboxController.text);
    createInventaris.jumlah = int.parse(_jumlahTextboxController.text);  
    createInventaris.tanggalMasuk = _tanggalMasukTextboxController.text; 
    createInventaris.tanggalKedaluwarsa = _tanggalKedaluwarsaTextboxController.text; 
    InventarisBloc.addInventarises(inventaris: createInventaris).then((value) { 
      Navigator.of(context).push(MaterialPageRoute( 
          builder: (BuildContext context) => const InventarisPage())); 
    }, onError: (error) { 
      showDialog( 
          context: context, 
          builder: (BuildContext context) => const WarningDialog( 
                description: "Simpan gagal, silahkan coba lagi", 
              )); 
    }); 
    setState(() { 
      _isLoading = false; 
    });
  }

  ubah() {
    setState(() { 
      _isLoading = true; 
    }); 
    Inventaris updateInventaris = Inventaris(id: widget.inventaris!.id!); 
    updateInventaris.nama = _namaTextboxController.text; 
    updateInventaris.harga = int.parse(_hargaTextboxController.text); 
    updateInventaris.jumlah = int.parse(_jumlahTextboxController.text); 
    updateInventaris.tanggalMasuk = _tanggalMasukTextboxController.text; 
    updateInventaris.tanggalKedaluwarsa = _tanggalKedaluwarsaTextboxController.text;
    InventarisBloc.updateInventarises(inventaris: updateInventaris).then((value) { 
      Navigator.of(context).push(MaterialPageRoute( 
          builder: (BuildContext context) => const InventarisPage())); 
    }, onError: (error) { 
      showDialog( 
          context: context, 
          builder: (BuildContext context) => const WarningDialog( 
                description: "Permintaan ubah data gagal, silahkan coba lagi", 
              )); 
    }); 
    setState(() { 
      _isLoading = false; 
    }); 
  }
}