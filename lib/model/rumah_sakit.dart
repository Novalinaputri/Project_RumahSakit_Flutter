class RumahSakit {
  int? id;
  String namaRumahSakit;
  String alamat;
  String noTelepon;
  String tipe;
  double latitude;
  double longitude;

  RumahSakit({
    this.id,
    required this.namaRumahSakit,
    required this.alamat,
    required this.noTelepon,
    required this.tipe,
    required this.latitude,
    required this.longitude,
  });

  factory RumahSakit.fromJson(Map<String, dynamic> json) {
    return RumahSakit(
      id: json['id'],
      namaRumahSakit: json['nama_rumah_sakit'],
      alamat: json['alamat'],
      noTelepon: json['no_telepon'],
      tipe: json['tipe'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_rumah_sakit': namaRumahSakit,
      'alamat': alamat,
      'no_telepon': noTelepon,
      'tipe': tipe,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}