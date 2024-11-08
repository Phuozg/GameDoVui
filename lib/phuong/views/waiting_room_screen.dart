import 'package:dadd/phuong/controllers/room_controller.dart';
import 'package:dadd/phuong/models/user_model.dart';
import 'package:dadd/phuong/views/account_screen.dart';
import 'package:dadd/phuong/views/player_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaitingRoomScreen extends StatelessWidget {
  const WaitingRoomScreen(
      {super.key,
      required this.roomName,
      required this.quantityQuestion,
      required this.topic,
      required this.roomID});
  final String roomName;
  final int quantityQuestion;
  final String topic;
  final String roomID;

  @override
  Widget build(BuildContext context) {
    List<int> listQuantity = [10, 20, 30];
    int dropdownQuantityValue = quantityQuestion;
    final roomController = Get.put(RoomController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text('Phòng $roomName'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountScreen()));
              },
              icon: const Icon(Icons.person_outline))
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/image/background.jpg'),
                fit: BoxFit.cover)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 80),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      child: StatefulBuilder(builder: (context, setState) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 30,
                          child: DropdownButton<int>(
                            isExpanded: true,
                            value: dropdownQuantityValue,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            onChanged: (int? value) {
                              setState(() {
                                dropdownQuantityValue = value!;
                              });
                            },
                            items: listQuantity
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                          ),
                        );
                      }))
                ],
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: ListView.builder(
                    itemBuilder: (context, index) {},
                  )),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    'Mời bạn',
                    style: TextStyle(color: Colors.white),
                  )),
              const Icon(
                Icons.timer_sharp,
                size: 50,
              ),
              const Text('5 giây'),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(200, 40)),
                  child: const Text(
                    'Sẵn sàng',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
