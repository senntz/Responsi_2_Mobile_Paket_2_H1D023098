import 'dart:convert'; 
import 'package:goonmarket/helpers/api.dart'; 
import 'package:goonmarket/helpers/api_url.dart'; 
import 'package:goonmarket/model/inventaris.dart'; 

class InventarisBloc { 
  static Future<List<Inventaris>> getInventarises() async { 
    String apiUrl = ApiUrl.listInventaris; 
    var response = await Api().get(apiUrl); 
    var jsonObj = json.decode(response.body); 
    List<dynamic> listInventarises = (jsonObj as Map<String, dynamic>)['data']; 
    List<Inventaris> inventarises = []; 
    for (int i = 0; i < listInventarises.length; i++) { 
      inventarises.add(Inventaris.fromJson(listInventarises[i])); 
    } 
    return inventarises; 
  } 

  static Future addInventarises({Inventaris? inventaris}) async { 
    String apiUrl = ApiUrl.createInventaris; 
    var body = { 
      "nama": inventaris!.nama, 
      "harga": inventaris.harga.toString(),
      "jumlah": inventaris.jumlah.toString(),
      "tanggal_masuk": inventaris.tanggalMasuk,
      "tanggal_kedaluwarsa": inventaris.tanggalKedaluwarsa 
    }; 
    var response = await Api().post(apiUrl, body); 
    var jsonObj = json.decode(response.body); 
    return jsonObj['status']; 
  } 

  static Future updateInventarises({required Inventaris inventaris}) async { 
    String apiUrl = ApiUrl.updateInventaris(int.parse(inventaris.id!)); 
    print(apiUrl); 
    var body = { 
      "nama": inventaris.nama, 
      "harga": inventaris.harga.toString(),
      "jumlah": inventaris.jumlah.toString(),
      "tanggal_masuk": inventaris.tanggalMasuk,
      "tanggal_kedaluwarsa": inventaris.tanggalKedaluwarsa 
    }; 
    print("Body : $body"); 
    var response = await Api().put(apiUrl, jsonEncode(body)); 
    var jsonObj = json.decode(response.body); 
    return jsonObj['status']; 
  } 

  static Future<bool> deleteInventaris({int? id}) async { 
    String apiUrl = ApiUrl.deleteInventaris(id!); 
    var response = await Api().delete(apiUrl); 
    var jsonObj = json.decode(response.body); 
    return (jsonObj as Map<String, dynamic>)['data']; 
  } 
}