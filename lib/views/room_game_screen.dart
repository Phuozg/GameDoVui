import 'package:dadd/views/account_screen.dart';
import 'package:dadd/views/room_template.dart';
import 'package:flutter/material.dart';

class RoomGameScreen extends StatelessWidget {
  const RoomGameScreen({super.key});
  @override
  Widget build(BuildContext context) {
    showSearchRoomDialog() {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Center(child: Text('Tìm phòng')),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextField(
                        decoration: InputDecoration(
                            labelText: 'Nhập mã phòng',
                            border: OutlineInputBorder()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                              child: const Text(
                                'Tìm',
                                style: TextStyle(color: Colors.white),
                              )),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text(
                                'Hủy',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ));
    }

    showCreateRoomDialog() {
      List<String> listTopic = <String>[
        'Bóng đá',
        'Lịch sử',
        'Khoa học',
        'Địa lý'
      ];
      String dropdownTopicValue = listTopic.first;
      List<int> listQuantity = [10, 20, 30];
      int dropdownQuantityValue = listQuantity.first;
      showDialog(
          context: context,
          builder: (_) => StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: const Center(child: Text('Tạo phòng')),
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: dropdownTopicValue,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.black54,
                            ),
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
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: DropdownButton<int>(
                            isExpanded: true,
                            value: dropdownQuantityValue,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.black54,
                            ),
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
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue),
                                child: const Text(
                                  'Tạo phòng',
                                  style: TextStyle(color: Colors.white),
                                )),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: const Text(
                                  'Hủy',
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('Phòng'),
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
          padding: const EdgeInsets.fromLTRB(30, 80, 30, 80),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: ListView(
                  children: [
                    roomTemplate(context, '1234', 3, 10, 'Lịch sử'),
                    roomTemplate(context, '34AC', 2, 30, 'Bóng đá'),
                    roomTemplate(context, 'AD99', 4, 20, 'Địa lý'),
                    roomTemplate(context, '00DC', 1, 20, 'Khoa học')
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    showSearchRoomDialog();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(200, 40)),
                  child: const Text(
                    'Tìm phòng',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )),
              ElevatedButton(
                  onPressed: () {
                    showCreateRoomDialog();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(200, 40)),
                  child: const Text(
                    'Tạo phòng',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
