// To parse this JSON data, do
//
//     final modelPemenang = modelPemenangFromJson(jsonString);

import 'dart:convert';

ModelPemenang modelPemenangFromJson(String str) =>
    ModelPemenang.fromJson(json.decode(str));

String modelPemenangToJson(ModelPemenang data) => json.encode(data.toJson());

class ModelPemenang {
  String nop;
  String nama;
  String alamat;
  String hadiah;

  ModelPemenang({
    required this.nop,
    required this.nama,
    required this.alamat,
    required this.hadiah,
  });

  factory ModelPemenang.fromJson(Map<String, dynamic> json) => ModelPemenang(
        nop: json["nop"],
        nama: json["nama"],
        alamat: json["alamat"],
        hadiah: json["hadiah"],
      );

  Map<String, dynamic> toJson() => {
        "nop": nop,
        "nama": nama,
        "alamat": alamat,
        "hadiah": hadiah,
      };
}
