import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/rumah_sakit.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.139.144:8000/api/rumah-sakit';

  // Ambil semua data rumah sakit
  static Future<List<RumahSakit>> fetchRumahSakit() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        List jsonData = json.decode(res.body);
        return jsonData.map((e) => RumahSakit.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat data. Status: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data: $e');
    }
  }

  // Tambah data baru
  static Future<Map<String, dynamic>> tambahRumahSakit(RumahSakit rumahSakit) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(rumahSakit.toJson()),
      );

      if (res.statusCode == 201) {
        return {'success': true, 'message': '✅ Data berhasil ditambahkan'};
      } else {
        return {
          'success': false,
          'message': '❌ Gagal menambahkan. Status: ${res.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': '⚠ Error: $e'};
    }
  }

  // Update data rumah sakit
  static Future<Map<String, dynamic>> updateRumahSakit(int id, RumahSakit rumahSakit) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(rumahSakit.toJson()),
      );

      if (res.statusCode == 200) {
        return {'success': true, 'message': '✅ Data berhasil diupdate'};
      } else {
        return {
          'success': false,
          'message': '❌ Gagal update. Status: ${res.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': '⚠ Error: $e'};
    }
  }

  // Hapus data rumah sakit
  static Future<Map<String, dynamic>> deleteRumahSakit(int id) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl/$id'));

      if (res.statusCode == 200) {
        return {'success': true, 'message': '🗑 Data berhasil dihapus'};
      } else {
        return {
          'success': false,
          'message': '❌ Gagal hapus. Status: ${res.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': '⚠ Error: $e'};
    }
  }
}