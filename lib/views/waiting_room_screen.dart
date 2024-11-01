import 'package:dadd/views/account_screen.dart';
import 'package:dadd/views/player_template.dart';
import 'package:flutter/material.dart';

class WaitingRoomScreen extends StatelessWidget {
  const WaitingRoomScreen(
      {super.key,
      required this.roomName,
      required this.quantityPlayer,
      required this.quantityQuestion,
      required this.topic});
  final String roomName;
  final int quantityPlayer;
  final int quantityQuestion;
  final String topic;
  @override
  Widget build(BuildContext context) {
    List<String> listTopic = <String>[
      'Bóng đá',
      'Lịch sử',
      'Khoa học',
      'Địa lý'
    ];
    String dropdownTopicValue = topic;
    List<int> listQuantity = [10, 20, 30];
    int dropdownQuantityValue = quantityQuestion;
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
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: dropdownTopicValue,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            onChanged: (String? value) {
                              setState(() {
                                dropdownTopicValue = value!;
                              });
                            },
                            items: listTopic
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        );
                      })),
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
                child: ListView(
                  children: [
                    playerTemplate(context, 'Toàn', 3, '1'),
                    playerTemplate(context, 'Mi', 2, '32'),
                    playerTemplate(context, 'Phú', 2, '3'),
                    playerTemplate(context, '', 0, '')
                  ],
                ),
              ),
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
