import 'package:flutter/material.dart';
import 'package:rumahsakitapi/screen/edit_rumah_sakit.dart';
import 'package:rumahsakitapi/screen/tambah_rumah_sakit.dart';
import '../model/rumah_sakit.dart';
import '../service/api_service.dart';
import 'detail_rumah_sakit.dart';

class ListRumahSakitScreen extends StatefulWidget {
  @override
  State<ListRumahSakitScreen> createState() => _ListRumahSakitScreenState();
}

class _ListRumahSakitScreenState extends State<ListRumahSakitScreen> {
  late Future<List<RumahSakit>> rumahSakitList;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      rumahSakitList = ApiService.fetchRumahSakit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Daftar Rumah Sakit",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700.withOpacity(0.9),
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFBBDEFB), Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<RumahSakit>>(
          future: rumahSakitList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.blue));
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('❌ Gagal memuat data', style: TextStyle(color: Colors.red)),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Belum ada data rumah sakit', style: TextStyle(color: Colors.black54)),
              );
            } else {
              final list = snapshot.data!;
              return RefreshIndicator(
                onRefresh: () async => _refresh(),
                color: Colors.blue,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 100, 16, 80),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final rs = list[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade700,
                          child: const Icon(Icons.local_hospital, color: Colors.white),
                        ),
                        title: Text(
                          rs.namaRumahSakit,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          rs.alamat,
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditRumahSakitScreen(rumahSakit: rs),
                                  ),
                                );
                                if (result == true) _refresh();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Konfirmasi"),
                                    content: const Text("Yakin ingin menghapus data ini?"),
                                    actions: [
                                      TextButton(
                                        child: const Text("Batal"),
                                        onPressed: () => Navigator.pop(context, false),
                                      ),
                                      TextButton(
                                        child: const Text("Hapus"),
                                        onPressed: () => Navigator.pop(context, true),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  final res = await ApiService.deleteRumahSakit(rs.id!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(res['message']),
                                      backgroundColor: res['success'] ? Colors.green : Colors.red,
                                    ),
                                  );
                                  if (res['success']) _refresh();
                                }
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailRumahSakitScreen(rumahSakit: rs),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahRumahSakitScreen()),
          );
          if (result == true) _refresh();
        },
        label: const Text("Tambah RS"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
    );
  }
}
