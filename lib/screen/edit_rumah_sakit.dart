import 'package:flutter/material.dart';
import '../model/rumah_sakit.dart';
import '../service/api_service.dart';

class EditRumahSakitScreen extends StatefulWidget {
  final RumahSakit rumahSakit;

  const EditRumahSakitScreen({super.key, required this.rumahSakit});

  @override
  State<EditRumahSakitScreen> createState() => _EditRumahSakitScreenState();
}

class _EditRumahSakitScreenState extends State<EditRumahSakitScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _telpController;
  late TextEditingController _tipeController;
  late TextEditingController _latController;
  late TextEditingController _longController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.rumahSakit.namaRumahSakit);
    _alamatController = TextEditingController(text: widget.rumahSakit.alamat);
    _telpController = TextEditingController(text: widget.rumahSakit.noTelepon);
    _tipeController = TextEditingController(text: widget.rumahSakit.tipe);
    _latController = TextEditingController(text: widget.rumahSakit.latitude.toString());
    _longController = TextEditingController(text: widget.rumahSakit.longitude.toString());
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    double? lat = double.tryParse(_latController.text);
    double? long = double.tryParse(_longController.text);

    if (lat == null || long == null) {
      _showMessage('Latitude dan Longitude harus berupa angka', isError: true);
      return;
    }

    final updatedRs = RumahSakit(
      id: widget.rumahSakit.id,
      namaRumahSakit: _namaController.text,
      alamat: _alamatController.text,
      noTelepon: _telpController.text,
      tipe: _tipeController.text,
      latitude: lat,
      longitude: long,
    );

    setState(() => _isLoading = true);

    final result = await ApiService.updateRumahSakit(widget.rumahSakit.id!, updatedRs);

    setState(() => _isLoading = false);

    _showMessage(result['message'], isError: !result['success']);
    if (result['success']) Navigator.pop(context, true);
  }

  void _showMessage(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.blue))
            : SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.blue),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Edit Rumah Sakit",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.local_hospital, color: Colors.blueAccent),
                ],
              ),
              const SizedBox(height: 20),

              // Form Card
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 5,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildInput("Nama Rumah Sakit", Icons.local_hospital, _namaController),
                        _buildInput("Alamat", Icons.location_on, _alamatController, maxLines: 2),
                        _buildInput("No Telepon", Icons.phone, _telpController),
                        _buildInput("Tipe", Icons.category, _tipeController),
                        _buildInput("Latitude", Icons.map, _latController, keyboardType: TextInputType.number),
                        _buildInput("Longitude", Icons.map_outlined, _longController, keyboardType: TextInputType.number),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.save_alt),
                            label: const Text("Simpan"),
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, IconData icon, TextEditingController controller,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (val) => val == null || val.isEmpty ? "$label tidak boleh kosong" : null,
      ),
    );
  }
}
