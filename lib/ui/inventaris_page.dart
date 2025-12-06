import 'package:flutter/material.dart';
import 'package:goonmarket/bloc/logout_bloc.dart';
import 'package:goonmarket/bloc/inventaris_bloc.dart';
import 'package:goonmarket/model/inventaris.dart';
import 'package:goonmarket/ui/login_page.dart';
import 'package:goonmarket/ui/inventaris_detail.dart';
import 'package:goonmarket/ui/inventaris_form.dart';

class InventarisPage extends StatefulWidget {
  const InventarisPage({super.key});

  @override
  _InventarisPageState createState() => _InventarisPageState();
}

class _InventarisPageState extends State<InventarisPage> {
  late Future<List<Inventaris>> _inventarisFuture;

  @override
  void initState() {
    super.initState();
    _inventarisFuture = InventarisBloc.getInventarises();
  }

  void _refreshData() {
    setState(() {
      _inventarisFuture = InventarisBloc.getInventarises();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Inventaris GoonMarket'),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InventarisForm()),
                );
                if (result == true) {
                  _refreshData();
                }
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.shopping_bag, color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'GoonMarket',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.refresh, color: Color(0xFF2E7D32)),
              title: const Text('Refresh Data'),
              onTap: () {
                Navigator.pop(context);
                _refreshData();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFF2E7D32)),
              title: const Text('Logout'),
              onTap: () async {
                await LogoutBloc.logout().then((value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                          (route) => false)
                    });
              },
            )
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2E7D32).withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: FutureBuilder<List<Inventaris>>(
          future: _inventarisFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, 
                      color: Color(0xFF2E7D32), size: 64),
                    const SizedBox(height: 16),
                    Text('Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                      ),
                      onPressed: _refreshData,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, 
                      color: const Color(0xFF2E7D32).withOpacity(0.5), 
                      size: 80),
                    const SizedBox(height: 16),
                    const Text(
                      'Tidak ada inventaris',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tambahkan inventaris baru dengan klik tombol +',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListInventaris(list: snapshot.data);
          },
        ),
      ),
    );
  }
}

class ListInventaris extends StatelessWidget {
  final List<Inventaris>? list;
  const ListInventaris({Key? key, this.list}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemInventaris(
          inventaris: list![i],
        );
      },
    );
  }
} 

class ItemInventaris extends StatelessWidget {
  final Inventaris inventaris;
  const ItemInventaris({Key? key, required this.inventaris}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InventarisDetail(
              inventaris: inventaris,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.inventory_2,
                color: Color(0xFF2E7D32),
                size: 28,
              ),
            ),
            title: Text(
              inventaris.nama ?? 'Nama tidak tersedia',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.storage,
                    size: 16,
                    color: const Color(0xFF2E7D32).withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Stok: ${inventaris.jumlah ?? 0}',
                    style: TextStyle(
                      color: const Color(0xFF2E7D32),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF2E7D32),
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}