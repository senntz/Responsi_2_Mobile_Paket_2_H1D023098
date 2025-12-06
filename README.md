# GoonMarket - Responsi 2 Praktikum Pemrograman Mobile
GoonMarket adalah aplikasi mobile berbasis Flutter untuk manajemen inventaris. Aplikasi ini memungkinkan pengguna untuk melakukan operasi CRUD (Create, Read, Update, Delete) pada data inventaris dengan sistem autentikasi berbasis token.

```
Nama = Muhammad Fikri Firmansyah
NIM = H1D023098
Shift Baru = D
Shift Asal = D
```
---
## Demo Aplikasi
Berikut tampilan aplikasi dan demo penggunaannya <br>

https://github.com/user-attachments/assets/c326a393-481b-4763-a0ab-84ee15d8cf5b

## Teknologi yang Digunakan
* Framework: Flutter
* State Management: BLoC Pattern
* HTTP Client: http package
* Local Storage: shared_preferences
* Backend: REST API (localhost:8080)

## 🏗️ Arsitektur Aplikasi
Aplikasi ini menggunakan arsitektur BLoC Pattern dengan struktur sebagai berikut:
```
lib/
├── bloc/           # Business Logic Component
├── helpers/        # Helper classes (API, Exception, UserInfo)
├── model/          # Data models
├── ui/             # User Interface pages
└── widget/         # Reusable widgets
```
Alur Data
```
UI Layer → BLoC Layer → Helper Layer → API → Backend
                ↓
            Model Layer
```

## 📦 Model Layer
Model layer mendefinisikan struktur data yang digunakan dalam aplikasi.
### 1. Inventaris Model (`lib/model/inventaris.dart`)
Tujuan: Merepresentasikan data inventaris barang.
```
class Inventaris {
  String? id;
  String? nama;
  var harga;
  var jumlah;
  String? tanggalMasuk;
  String? tanggalKedaluwarsa;
}
```
Properti:
* `id`: ID unik inventaris
* `nama`: Nama barang
* `harga`: Harga barang (dynamic type)
* `jumlah`: Jumlah stok
* `tanggalMasuk`: Tanggal barang masuk (format: YYYY-MM-DD)
* `tanggalKedaluwarsa`: Tanggal kedaluwarsa (format: YYYY-MM-DD)

Method:

`fromJson()`: Mengkonversi JSON dari API menjadi object Inventaris

### 2. Login Model (`lib/model/login.dart`)
Tujuan: Menangani response dari endpoint login.
```
class Login {
  int? code;
  bool? status;
  String? token;
  int? userID;
  String? userEmail;
}
```
Properti:
* `code`: HTTP status code (200 = sukses)
* `status`: Status response (true/false)
* `token`: JWT token untuk autentikasi
* `userID`: ID user yang login
* `userEmail`: Email user

Logic:
* Jika `code == 200`: Parse semua data termasuk token dan user info
* Jika gagal: Hanya return code dan status

### 3. Registrasi Model (`lib/model/registrasi.dart`)
Tujuan: Menangani response dari endpoint registrasi.
```
class Registrasi {
  int? code;
  bool? status;
  String? data;
}
```
Properti:
* `code`: HTTP status code
* `status`: Status registrasi
* `data`: Pesan response dari server

### 4. Produk Model ( `lib/model/produk.dart` )
Tujuan: Model tambahan untuk data produk (belum diimplementasi dalam UI).
```
class Produk {
  String? id;
  String? kodeProduk;
  String? namaProduk;
  var hargaProduk;
}
```

## 🔄 BLoC Layer
BLoC (Business Logic Component) menangani logika bisnis dan komunikasi dengan API.
### 1. Inventaris BLoC (`lib/bloc/inventaris_bloc.dart`)
Tujuan: Mengelola operasi CRUD inventaris.
Method-method:
`getInventarises()`
```static Future<List<Inventaris>> getInventarises()```
* Fungsi: Mengambil semua data inventaris
* Endpoint: `GET /inventaris`
* Return: List of Inventaris objects
* Proses:
  1. Request ke API
  2. Parse JSON response
  3. Convert ke List<Inventaris>

`addInventarises()`
```static Future addInventarises({Inventaris? inventaris})```
* Fungsi: Menambah inventaris baru
* Endpoint: `POST /inventaris`
* Parameter: Object Inventaris
* Body: nama, harga, jumlah, tanggal_masuk, tanggal_kedaluwarsa
* Return: Status response

`updateInventarises()`
```static Future updateInventarises({required Inventaris inventaris})```
* Fungsi: Mengupdate data inventaris
* Endpoint: `PUT /inventaris/{id}`
* Parameter: Object Inventaris dengan ID
* Body: JSON encoded data
* Return: Status response

`deleteInventaris()`
```static Future<bool> deleteInventaris({int? id})```
* Fungsi: Menghapus inventaris
* Endpoint: `DELETE /inventaris/{id}`
* Parameter: ID inventaris
* Return: Boolean status

### 2. Login BLoC (`lib/bloc/login_bloc.dart`)
Tujuan: Menangani proses autentikasi login.
```static Future<Login> login({String? email, String? password})```
* Fungsi: Melakukan login user
* Endpoint: `POST /login`
* Parameter: email, password
* Return: Object Login (berisi token dan user info)

### 3. Registrasi BLoC (`lib/bloc/registrasi_bloc.dart`)
Tujuan: Menangani proses pendaftaran user baru.
```static Future<Registrasi> registrasi({String? nama, String? email, String? password})```
* Fungsi: Mendaftarkan user baru
* Endpoint: `POST /registrasi`
* Parameter: nama, email, password
* Return: Object Registrasi

### 4. Logout BLoC (`lib/bloc/logout_bloc.dart`)
Tujuan: Menangani proses logout.
```static Future logout()```
* Fungsi: Menghapus semua data user dari local storage
* Proses: Memanggil `UserInfo().logout()` untuk clear SharedPreferences

## 🛠️ Helper Layer
Helper layer menyediakan fungsi-fungsi utility dan koneksi ke backend.
### 1. API Helper (`lib/helpers/api.dart`)
Tujuan: Menangani semua HTTP request ke backend.
Method-method:
`post()`
```Future<dynamic> post(dynamic url, dynamic data)```
* Fungsi: HTTP POST request
* Headers: Authorization Bearer token
* Body: Form data
* Exception Handling: SocketException untuk no internet

`get()`
```Future<dynamic> get(dynamic url)```

* Fungsi: HTTP GET request
* Headers: Authorization Bearer token
* Use Case: Mengambil list data

`put()`
```Future<dynamic> put(dynamic url, dynamic data)```
* Fungsi: HTTP PUT request
* Headers:
  * Authorization Bearer token
  * Content-Type: application/json
* Body: JSON encoded
* Use Case: Update data

`delete()`
```Future<dynamic> delete(dynamic url)```
* Fungsi: HTTP DELETE request
* Headers: Authorization Bearer token
* Use Case: Hapus data

`_returnResponse()`
```dynamic _returnResponse(http.Response response)```
* Fungsi: Menangani response berdasarkan status code
* Status Codes:
  * `200`: Success → return response
  * `400`: Bad Request → throw BadRequestException
  * `401/403`: Unauthorized → throw UnauthorisedException
  * `422`: Invalid Input → throw InvalidInputException
  * `500`: Server Error → throw FetchDataException



### 2. API URL Helper (`lib/helpers/api_url.dart`)
Tujuan: Mengelola semua endpoint API.
```class ApiUrl {
  static const String baseUrl = 'http://localhost:8080';
  
  // Static endpoints
  static const String registrasi = baseUrl + '/registrasi';
  static const String login = baseUrl + '/login';
  static const String listInventaris = baseUrl + '/inventaris';
  static const String createInventaris = baseUrl + '/inventaris';
  
  // Dynamic endpoints
  static String updateInventaris(int id) => baseUrl + '/inventaris/$id';
  static String showInventaris(int id) => baseUrl + '/inventaris/$id';
  static String deleteInventaris(int id) => baseUrl + '/inventaris/$id';
}
```
Endpoint List:
| Method | Endpoint | Fungsi |
|---|---|---|
| POST | /registrasi | Daftar user baru |
| POST | /login | Login user |
| GET | /inventaris | Ambil semua inventaris |
| POST | /inventaris | Tambah inventaris |
| GET | /inventaris/{id} | Detail inventaris |
| PUT | /inventaris/{id} | Update inventaris |
| DELETE | /inventaris/{id} | Hapus inventaris |

### 3. App Exception Helper (`lib/helpers/app_exception.dart`)
Tujuan: Mendefinisikan custom exception classes.
Exception Types:
```
// Base Exception
class AppException implements Exception {
  final _message;
  final _prefix;
}
```
Custom Exceptions:
* `FetchDataException`: Error saat komunikasi dengan server
* `BadRequestException`: Request tidak valid (400)
* `UnauthorisedException`: User tidak terautentikasi (401/403)
* `InvalidInputException`: Input tidak valid (422)
* `UnprocessableEntityException`: Entity tidak dapat diproses

### 4. User Info Helper (`lib/helpers/user_info.dart`)
Tujuan: Mengelola penyimpanan data user di local storage menggunakan SharedPreferences.
Method-method:
Token Management
```
Future setToken(String value)  // Simpan token
Future<String?> getToken()     // Ambil token
```
User ID Management
```
Future setUserID(int value)    // Simpan user ID
Future<int?> getUserID()       // Ambil user ID
```
Logout
```
Future logout()                // Clear semua data
```

## 🎨 UI Layer
UI Layer menghandle tampilan dan interaksi user.
### 1. Login Page (`lib/ui/login_page.dart`)
**Tujuan**: Halaman untuk user login. <br>
**Komponen**:
State Variables
```
final _formKey = GlobalKey<FormState>();
bool _isLoading = false;
final _emailTextboxController = TextEditingController();
final _passwordTextboxController = TextEditingController();
```
Widget Components
`_buildHeader()`
* Menampilkan logo aplikasi
* Judul "GoonMarket"
* Subtitle "Selamat datang kembali"

`_emailTextField()`
* Input field untuk email
* Validation: Email tidak boleh kosong
* Icon: Email icon
* Keyboard type: Email address

`_passwordTextField()`
* Input field untuk password
* Validation: Password tidak boleh kosong
* Obscure text: true (password tersembunyi)
* Icon: Lock icon

`_buttonLogin()`
* Tombol untuk submit login
* Menampilkan loading indicator saat proses login
* Trigger validation sebelum submit

`_menuRegistrasi()`
* Link untuk ke halaman registrasi
* Text: "Belum punya akun? Daftar di sini"

Method `_submit()`
Alur Proses:
1. Save form state
2. Set loading = true
3. Panggil LoginBloc.login()
4. Jika code == 200:
   * Simpan token ke SharedPreferences
   * Simpan userID ke SharedPreferences
   * Navigate ke InventarisPage
5. Jika gagal:
   * Tampilkan WarningDialog

### 2. Registrasi Page (`lib/ui/registrasi_page.dart`)
**Tujuan**: Halaman untuk pendaftaran user baru. <br>
**Komponen**:
State Variables
```
final _formKey = GlobalKey<FormState>();
bool _isLoading = false;
final _namaTextboxController = TextEditingController();
final _emailTextboxController = TextEditingController();
final _passwordTextboxController = TextEditingController();
```
Widget Components
`_namaTextField()`
* Input untuk nama lengkap
* Validation: Minimal 3 karakter

`_emailTextField()`
* Input untuk email
* Validation:
  * Tidak boleh kosong
  * Format email harus valid (regex pattern)

`_passwordTextField()`
* Input untuk password
* Validation: Minimal 6 karakter
* Obscure text: true

`_passwordKonfirmasiTextField()`
* Input untuk konfirmasi password
* Validation: Harus sama dengan password
* Obscure text: true

Method `_submit()`
Alur Proses:
1. Validate form
2. Set loading = true
3. Panggil RegistrasiBloc.registrasi()
4. Success:
   * Tampilkan SuccessDialog
   * Navigate kembali ke LoginPage
5. Error:
   * Tampilkan WarningDialog
6. Set loading = false

### 3. Inventaris Page (`lib/ui/inventaris_page.dart`)
**Tujuan**: Halaman utama menampilkan list inventaris. <br>
**Komponen**:
State Variables
```
late Future<List<Inventaris>> _inventarisFuture;
```
Lifecycle Methods
`initState()`
* Inisialisasi `_inventarisFuture`
* Load data inventaris saat halaman dibuka

`_refreshData()`

* Reload data inventaris
* Dipanggil setelah add/edit/delete

UI Components
**AppBar**
* Title: "List Inventaris GoonMarket"
* Action button: Add icon (navigate ke InventarisForm)
**Drawer**
* Header dengan logo dan nama app
* Menu Refresh Data
* Menu Logout
**Body - FutureBuilder**
```
FutureBuilder<List<Inventaris>>
```
**State Handling**:
1. Loading: Tampilkan CircularProgressIndicator
2. Error: Tampilkan error message + button "Coba Lagi"
3. Empty: Tampilkan "Tidak ada inventaris" + hint
4. Success: Tampilkan ListInventaris

Child Components
`ListInventaris`
* ListView.builder untuk list item
* Padding: 12px
* Render ItemInventaris untuk setiap data

`ItemInventaris`
* Card dengan border radius 12
* Leading icon: Inventory icon dengan background hijau
* Title: Nama inventaris
* Subtitle: Jumlah stok dengan icon
* Trailing: Arrow forward icon
* OnTap: Navigate ke InventarisDetail

### 4. Inventaris Detail (`lib/ui/inventaris_detail.dart`)
**Tujuan**: Menampilkan detail lengkap inventaris dan opsi edit/delete. <br>
**Komponen**:
Widget Components
`_buildHeader()`
* Container dengan icon inventory
* Background: Hijau dengan shadow
* Nama inventaris sebagai judul

`_buildDetailCard()`
* Card dengan border hijau di kiri
* Menampilkan 4 detail item:
  1. Harga (dengan format currency)
  2. Jumlah stok
  3. Tanggal masuk
  4. Tanggal kedaluwarsa

`_detailItem()` Parameter:
* icon: Icon untuk item
* label: Label item
* value: Nilai item

Tampilan:
* Icon dengan background hijau muda
* Label dengan font kecil abu-abu
* Value dengan font besar bold

`_formatCurrency()`

* Format angka dengan separator titik
* Contoh: 100000 → 100.000
* Handle error jika bukan angka

`_tombolHapusEdit()`

* Row dengan 2 button:
  1. EDIT: Hijau → Navigate ke InventarisForm
  2. HAPUS: Merah → Trigger confirmHapus()

Method `confirmHapus()`
Alur Proses:

1. Tampilkan AlertDialog konfirmasi
2. Jika user klik "Ya, Hapus":
   * Panggil InventarisBloc.deleteInventaris()
   * Success: Navigate ke InventarisPage
   * Error: Tampilkan WarningDialog
3. Jika user klik "Batal": Tutup dialog

### 5. Inventaris Form (`lib/ui/inventaris_form.dart`)
**Tujuan**: Form untuk tambah/edit inventaris. <br>
**Komponen**:
State Variables
```
final _formKey = GlobalKey<FormState>();
bool _isLoading = false;
String judul = "TAMBAH INVENTARIS GOONMARKET";
String tombolSubmit = "SIMPAN";
// TextEditingControllers
```
Lifecycle Methods
`initState()`
* Panggil `isUpdate()` untuk cek mode form

`isUpdate()`
* Jika widget.inventaris != null:
  * Mode: UPDATE
  * Judul: "UBAH INVENTARIS GOONMARKET"
  * Tombol: "UBAH"
  * Fill form dengan data existing
* Jika null:
  * Mode: CREATE
  * Judul: "TAMBAH INVENTARIS GOONMARKET"
  * Tombol: "SIMPAN"

Widget Components <br>
Form Fields (semua dengan style konsisten):

1. `_namaTextField()`
   * Label: "Nama Inventaris"
   * Validation: Tidak boleh kosong

3. `_hargaTextField()`
   * Label: "Harga"
   * Keyboard: Number
   * Validation: Tidak boleh kosong

4. `_jumlahTextField()`
   * Label: "Jumlah"
   * Keyboard: Number
   * Validation: Tidak boleh kosong

5. `_tanggalMasukTextField()`
   * Label: "Tanggal Masuk (YYYY-MM-DD)"
   * Validation: Tidak boleh kosong


6. `_tanggalKedaluwarsaTextField()`
   * Label: "Tanggal Kedaluwarsa (YYYY-MM-DD)"
   * Validation: Tidak boleh kosong

`_buttonSubmit()`
* Full width button
* Tampilkan loading indicator saat processing
* OnPressed:
  * Validate form
  * Jika valid: Panggil simpan() atau ubah()

Method `simpan()`
Alur Proses:
1. Set loading = true
2. Create object Inventaris baru
3. Parse harga dan jumlah ke integer
4. Panggil `InventarisBloc.addInventarises()`
5. Success: Navigate ke InventarisPage
6. Error: Tampilkan WarningDialog
7. Set loading = false

Method `ubah()`
Alur Proses:
1. Set loading = true
2. Create object Inventaris dengan ID existing
3. Parse harga dan jumlah ke integer
4. Panggil `InventarisBloc.updateInventarises()`
5. Success: Navigate ke InventarisPage
6. Error: Tampilkan WarningDialog
7. Set loading = false
