import 'package:flutter/material.dart';
import 'package:goonmarket/bloc/login_bloc.dart';
import 'package:goonmarket/helpers/user_info.dart';
import 'package:goonmarket/ui/inventaris_page.dart';
import 'package:goonmarket/ui/registrasi_page.dart';
import 'package:goonmarket/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login GoonMarket'),
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _emailTextField(),
                  const SizedBox(height: 16),
                  _passwordTextField(),
                  const SizedBox(height: 32),
                  _buttonLogin(),
                  const SizedBox(height: 24),
                  _menuRegistrasi()
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
            Icons.shopping_bag,
            color: Colors.white,
            size: 48,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'GoonMarket',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Selamat datang kembali',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
  //Membuat Textbox email
  Widget _emailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
        prefixIcon: const Icon(Icons.email, color: Color(0xFF2E7D32)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }
  //Membuat Textbox password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF2E7D32)),
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
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      },
    );
  }
  //Membuat Tombol Login
  Widget _buttonLogin() {
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
            : const Text(
                "Login",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) _submit();
          }
        },
      ),
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    LoginBloc.login(
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then((value) async {
      if (value.code == 200) { 
        await UserInfo().setToken(value.token.toString()); 
        await UserInfo().setUserID(int.parse(value.userID.toString())); 
        Navigator.pushReplacement(context, 
            MaterialPageRoute(builder: (context) => const InventarisPage())); 
      } else {
        showDialog( 
            context: context, 
            barrierDismissible: false, 
            builder: (BuildContext context) => const WarningDialog( 
                  description: "Login gagal, silahkan coba lagi", 
                )); 
      }
    });
  }
  // Membuat menu untuk membuka halaman registrasi
  Widget _menuRegistrasi() {
    return Center(
      child: Column(
        children: [
          const Text(
            "Belum punya akun?",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          InkWell(
            child: const Text(
              "Daftar di sini",
              style: TextStyle(
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegistrasiPage()));
            },
          ),
        ],
      ),
    );
  }
}