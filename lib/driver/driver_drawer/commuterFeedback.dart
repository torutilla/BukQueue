import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/commuter/commuter_drawer/feedback.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/models/providers/bookingProvider.dart';
import 'package:provider/provider.dart';

class CommuterFeedback extends StatefulWidget {
  const CommuterFeedback({super.key});

  @override
  _CommuterFeedbackState createState() => _CommuterFeedbackState();
}

class _CommuterFeedbackState extends State<CommuterFeedback> {
  String uid = '';
  String commuterName = '';
  Map<String, dynamic>? selectedFeedback;
  List<Map<String, dynamic>> feedbacks = [];

  double starValue = 1;

  @override
  void initState() {
    _getUID();
    super.initState();
  }

  Future<void> _loadFeedback(int index) async {
    if (feedbacks.isNotEmpty) {
      setState(() {
        selectedFeedback = feedbacks[index];
        starValue = selectedFeedback!['Rating'].toDouble();
        commuterName = selectedFeedback!['Commuter Name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Commuter Feedbacks',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: UserBasedFeedbacks(
            useCommuterName: true,
            onTapWidget: (index) {
              _loadFeedback(index);

              showDialog(
                  context: context,
                  builder: (context) {
                    return EditFeedbackClassInDialog(
                      customName: commuterName,
                      customHeight: ScreenUtil.parentHeight(context) * 0.6,
                      selectedFeedback: selectedFeedback,
                      enableEdit: false,
                      starValue: starValue,
                    );
                  });
            },
            futureBuild: _getFeedbacks(),
            height: ScreenUtil.parentHeight(context)),
      ),
    );
  }

  void _getUID() {
    BookingProvider provider =
        Provider.of<BookingProvider>(context, listen: false);
    uid = provider.bookingUserInfo['UID'];
  }

  Future<List<Map<String, dynamic>>> _getFeedbacks() async {
    final firestore = FirebaseFirestore.instance;

    final feedbackSnapshot = await firestore
        .collection('Feedback')
        .where('Driver UID', isEqualTo: uid)
        .get();
    final feedbackData = feedbackSnapshot.docs.map((e) => e.data()).toList();

    final commuterUIDs =
        feedbackData.map((entry) => entry['Commuter UID']).toSet().toList();

    final commuterSnapshot = await firestore
        .collection('Users')
        .where('UID', whereIn: commuterUIDs)
        .get();
    final commuterData = {
      for (var doc in commuterSnapshot.docs) doc['UID']: doc['Full Name']
    };

    for (var entry in feedbackData) {
      entry['Commuter Name'] =
          commuterData[entry['Commuter UID']] ?? 'Anonymous';
    }
    feedbacks = feedbackData;
    return feedbackData;
  }
}
