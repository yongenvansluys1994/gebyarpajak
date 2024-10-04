import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:gebyarpajak/app/modules/home/models/model_pemenang.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final controllervideo =
      VideoPlayerController.asset("assets/images/bg_video.mp4");
  bool visible = false;
  final player = AudioPlayer();
  final player2 = AudioPlayer();
  int ButtonStart = 0;
  late ModelPemenang modelPemenang1;
  String mainHadiah = 'Smartphone';
  String mainHadiahImage = 'assets/images/smartphone.png';
  RxList<ModelPemenang> daftarPemenang = <ModelPemenang>[].obs;

  void onInit() {
    super.onInit();
    fetchPemenang();
    modelPemenang1 = ModelPemenang(nop: "", nama: "", alamat: "", hadiah: "");
    controllervideo.initialize().then((_) {
      controllervideo.setLooping(true);
      controllervideo.play();
      visible = true;
    });
  }

  List<Map<String, String>> hadiahList = [
    {"name": "Smartphone", "image": "assets/images/smartphone.png"},
    {"name": "Sepedah Listrik", "image": "assets/images/sepedahlistrik.png"},
    {"name": "Motor", "image": "assets/images/motor.png"},
  ];

  void updateHadiah(int index) async {
    await player.play(AssetSource('sounds/impact.mp3'));
    mainHadiah = hadiahList[index]["name"]!; // Update the prize name
    mainHadiahImage = hadiahList[index]["image"]!; // Update the prize image
    print(mainHadiah);
    update(); // Notify the UI to refresh
  }

  void ClickStart() {
    ButtonStart = 1;
    update();
  }

  void ClickStop() async {
    ButtonStart = 2;
    update();

    try {
      final response = await http.get(
        Uri.parse(
            'https://yongen-bisa.com/gebyarpajak/undian.php?hadiah=$mainHadiah'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse); // This will print the entire JSON response

        // Update modelPemenang1 with the parsed JSON response
        modelPemenang1 = ModelPemenang.fromJson(jsonResponse);
        print('Updated modelPemenang1: $modelPemenang1');
        update();
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void ClickRefresh() async {
    ButtonStart = 0;
    EmptyPemenang();
    await player.stop();
    await player2.stop();
    update();
  }

  void SetujuiPemenang() async {
    var pemenangData = {
      'nop': modelPemenang1.nop,
      'nama': modelPemenang1.nama,
      'alamat': modelPemenang1.alamat,
      'hadiah': modelPemenang1.hadiah,
    };
    try {
      // Kirim data ke simpan_pemenang.php
      final response = await http.post(
        Uri.parse('https://yongen-bisa.com/gebyarpajak/simpan_pemenang.php'),
        body: pemenangData,
      );

      if (response.statusCode == 200) {
        fetchPemenang();
        print('Pemenang berhasil disimpan.');
        ButtonStart = 0;
        EmptyPemenang();
        await player.stop();
        await player2.stop();
        update();
      } else {
        print('Gagal menyimpan pemenang. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat menyimpan pemenang: $e');
    }
    // Tambahkan pemenang ke daftar pemenang
    //daftarPemenang.add(modelPemenang1);
    update();
  }

  void EmptyPemenang() {
    modelPemenang1 = ModelPemenang(nop: "", nama: "", alamat: "", hadiah: "");
  }

  void playAcak() async {
    await player.play(AssetSource('sounds/acak.mp3'));
  }

  void StopAcak() async {
    await player.stop();
    await Future.delayed(Duration(milliseconds: 01));
    await player.play(AssetSource('sounds/winner.mp3'));
  }

  void playWinner() async {}

  void playWinner2() {
    player.play(AssetSource('sounds/songwinner.mp3'));
  }

  void fetchPemenang() async {
    daftarPemenang.clear(); // Clear existing list
    try {
      final response = await http.get(
        Uri.parse('https://yongen-bisa.com/gebyarpajak/fetch_pemenang.php'),
      );

      if (response.statusCode == 200) {
        // Decode JSON response
        final List<dynamic> jsonResponse = json.decode(response.body);

        // Map JSON response to ModelPemenang list and update daftarPemenang
        daftarPemenang.addAll(jsonResponse.map((data) {
          return ModelPemenang.fromJson(data);
        }).toList());

        update(); // Trigger UI update
      } else {
        print('Gagal mengambil data pemenang. Status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error saat mengambil data pemenang: $error');
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
    await player.stop();
    await player2.stop();
  }
}
