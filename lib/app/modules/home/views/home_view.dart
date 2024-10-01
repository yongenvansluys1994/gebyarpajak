import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gebyarpajak/widgets/texts.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return Stack(
            children: [
              AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(milliseconds: 1000),
                child: Center(
                  child: Container(
                    width: 200.w,
                    child: VideoPlayer(controller.controllervideo),
                  ),
                ),
              ),
              Column(
                children: [
                  Texts.body1("Daftar Pemenang", color: Colors.white),
                  Container(
                    width: 45.w,
                    height: 30.h,
                    child: GetBuilder<HomeController>(
                      init: HomeController(),
                      builder: (controller) {
                        return Table(
                          border: TableBorder.all(color: Colors.black),
                          columnWidths: {
                            0: FlexColumnWidth(
                                1.2), // Kolom pertama, proporsi 1
                            1: FlexColumnWidth(1.5), // Kolom kedua, proporsi 1
                            2: FlexColumnWidth(1),
                          },
                          children: [
                            // Header row
                            TableRow(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 223, 150, 40)),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Texts.caption("NOP/NPWPD",
                                      isBold: true), // Data dari controller
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Texts.caption("NAMA",
                                      isBold: true), // Data dari controller
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Texts.caption("HADIAH",
                                      isBold: true), // Data dari controller
                                ),
                              ],
                            ),
                            // Data rows
                            ...controller.daftarPemenang
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              var pemenang = entry.value;
                              Color backgroundColor = index % 2 == 0
                                  ? Colors.white // Warna untuk indeks genap
                                  : Color.fromARGB(255, 215, 215,
                                      215)!; // Warna untuk indeks ganjil
                              return TableRow(
                                decoration:
                                    BoxDecoration(color: backgroundColor),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Texts.caption(
                                        pemenang.nop), // Data dari controller
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Texts.caption(pemenang.nama,
                                        maxLines: 2), // Data dari controller
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Texts.caption(pemenang.hadiah,
                                        maxLines: 2), // Data dari controller
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              Container(
                height: 100.h,
                width: 200.w,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Display the currently selected prize name
                            GetBuilder<HomeController>(
                              builder: (controller) {
                                return Column(
                                  children: [
                                    Text(
                                      "Hadiah yang dipilih: ${controller.mainHadiah}",
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                );
                              },
                            ),

                            // Image slider using CarouselSlider
                            GetBuilder<HomeController>(
                              builder: (controller) {
                                return CarouselSlider.builder(
                                  itemCount: controller.hadiahList.length,
                                  itemBuilder: (context, index, realIdx) {
                                    return Image.asset(
                                      controller.hadiahList[index]["image"]!,
                                      fit: BoxFit.cover,
                                      height: 200,
                                    );
                                  },
                                  options: CarouselOptions(
                                    height: 200,
                                    enlargeCenterPage: true,
                                    onPageChanged: (index, reason) {
                                      // Update the selected prize name and image
                                      controller.updateHadiah(index);
                                    },
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: 20),
                          ],
                        ),
                        Stack(
                          children: [
                            Image.asset(
                              'assets/images/box1.png',
                              width: 100.w,
                            ),
                            controller.ButtonStart == 1
                                ? Positioned(
                                    top: 10.20.w,
                                    left: 4.33.w,
                                    child: Image.asset(
                                      'assets/images/acak1.gif',
                                      width: 40.w,
                                    ),
                                  )
                                : controller.ButtonStart == 2
                                    ? Positioned(
                                        top: 9.50.w,
                                        left: 0.w,
                                        child: SizedBox(
                                          width: 100.w,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                width: 40.w,
                                                child: Texts.captionbig(
                                                    "${controller.modelPemenang1.nop}",
                                                    color: Colors.white,
                                                    isBold: true),
                                              ),
                                              Container(
                                                width: 40.w,
                                                child: Texts.captionbig(
                                                    "${controller.modelPemenang1.nama}",
                                                    maxLines: 1,
                                                    color: Colors.white,
                                                    isBold: true),
                                              )
                                            ],
                                          ),
                                        ))
                                    : SizedBox.shrink(),
                            controller.ButtonStart == 1
                                ? Positioned(
                                    top: 10.00.w,
                                    left: 53.9.w,
                                    child: Image.asset(
                                      'assets/images/acak2.gif',
                                      width: 40.w,
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                        controller.ButtonStart == 0
                            ? GestureDetector(
                                onTap: () {
                                  controller.ClickStart();
                                  controller.playAcak();
                                },
                                child: Image.asset(
                                  'assets/images/start.png',
                                  width: 20.w,
                                ),
                              )
                            : controller.ButtonStart == 1
                                ? GestureDetector(
                                    onTap: () {
                                      controller.ClickStop();
                                      controller.StopAcak();
                                      //controller.playWinner();
                                    },
                                    child: Image.asset(
                                      'assets/images/stop.png',
                                      width: 20.w,
                                    ),
                                  )
                                : controller.ButtonStart == 2
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.defaultDialog(
                                            middleText:
                                                "Refresh Data Pemenang ?",
                                            onCancel: () {
                                              Get.back();
                                            },
                                            onConfirm: () {
                                              Get.back();
                                              controller.ClickRefresh();
                                            },
                                          );
                                        },
                                        child: Image.asset(
                                          'assets/images/refresh.png',
                                          width: 20.w,
                                        ),
                                      )
                                    : SizedBox.shrink(),
                        controller.ButtonStart == 2
                            ? GestureDetector(
                                onTap: () {
                                  Get.defaultDialog(
                                    middleText: "Setujui Pemenang ?",
                                    onCancel: () {
                                      Get.back();
                                    },
                                    onConfirm: () {
                                      Get.back();
                                      controller.SetujuiPemenang();
                                    },
                                  );
                                },
                                child: Container(
                                  height: 7.h,
                                  child: Image.asset(
                                    'assets/images/setujui.png',
                                    width: 30.w,
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 7.h,
                              )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: ElevatedButton(
                    onPressed: () {
                      controller.player.stop();
                      controller.player2.stop();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.music_off,
                          size: 1.w,
                        ),
                        Text(" Matikan Lagu"),
                      ],
                    )),
              ),
            ],
          );
        },
      ),
    );
  }
}
