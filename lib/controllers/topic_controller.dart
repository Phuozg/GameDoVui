import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadd/models/topic_model.dart';
import 'package:get/get.dart';

class TopicController extends GetxController {
  static TopicController get instance => Get.find();

  final db = FirebaseFirestore.instance;
  RxList<TopicModel> topics = <TopicModel>[].obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    db.collection('Topic').snapshots().listen((snapshot) {
      topics.clear();
      for (var topic in snapshot.docs) {
        topics.add(TopicModel.fromSnapshot(topic));
      }
    });
  }

  String getTopicName(String topicID) {
    TopicModel filteredTopic = TopicModel.empty();
    for (var topic in topics) {
      if (topic.ID == topicID) {
        filteredTopic = topic;
      }
    }
    return filteredTopic.TopicName;
  }
}
