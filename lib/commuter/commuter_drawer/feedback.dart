import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/backButton.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/background.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/dropDownMenu.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/overlayEntryCard.dart';

import 'package:flutter_try_thesis/constants/utility_widgets/textFields.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/userSharedPreferences.dart';
import 'package:flutter_try_thesis/models/firestore_operations/firestoreOperations.dart';
import 'package:flutter_try_thesis/models/providers/bookingProvider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constants/constants.dart';
import '../../constants/screenSizes.dart';

class MyFeedbacks extends StatefulWidget {
  const MyFeedbacks({
    super.key,
  });

  @override
  State<MyFeedbacks> createState() => _MyFeedbacksState();
}

class _MyFeedbacksState extends State<MyFeedbacks> {
  FeedbackFirestoreComms feedbackFirestore = FeedbackFirestoreComms();
  OverlayEntry? overlayDatePicker;
  TextEditingController dateController = TextEditingController();
  TextEditingController bodyNumberController = TextEditingController();
  TextEditingController driverNameController = TextEditingController();
  TextEditingController zoneController = TextEditingController();
  Future? getFeedback;
  List<String> zoneList = [
    'Zone 1',
    'Zone 1-A',
    'Zone 1-B',
    'Zone 1-C',
    'Zone 1-D',
    'Zone 2',
    'Zone 2-A',
    'Zone 3',
    'Zone 3-A',
    'Zone 4',
    'Zone 4-A',
  ];

  bool anonymous = false;
  double starValue = 1;

  String uid = '';

  TextEditingController feedbackTextController = TextEditingController();

  bool dataLoaded = false;

  Map<String, dynamic> selectedFeedback = {};

  List<Map<String, dynamic>> feedbacks = [];
  @override
  void initState() {
    super.initState();
    getFeedback = _getFeedbacks();
    _getUID();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
            selectionColor: secondaryColor.withOpacity(0.5),
            cursorColor: primaryColor),
        colorScheme: ColorScheme(
            brightness: Theme.of(context).brightness,
            primary: primaryColor,
            onPrimary: Colors.white,
            secondary: accentColor,
            onSecondary: Colors.white,
            error: errorColor,
            onError: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black),
        datePickerTheme: DatePickerThemeData(
          dividerColor: grayInputBox,
          backgroundColor: Colors.white,
          dayOverlayColor: WidgetStatePropertyAll(
            secondaryColor.withOpacity(0.5),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size(ScreenUtil.parentWidth(context), 130),
            child: Stack(
              children: [
                BackgroundWithColor(),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                    top: 16.0,
                  ),
                  child: SvgPicture.asset(
                    height: 100,
                    'assets/images/Bukyo.svg',
                    colorFilter: ColorFilter.mode(
                        primaryColor.withOpacity(0.5), BlendMode.srcIn),
                  ),
                ),
                AppBar(
                  elevation: 10,
                  toolbarHeight: 60,
                  leading: BackbuttoninForm(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: const TextTitle(
                    text: 'Feedback',
                    fontWeight: FontWeight.w700,
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  bottom: PreferredSize(
                    preferredSize: Size(ScreenUtil.parentWidth(context), 60),
                    child: ColoredBox(
                      color: primaryColor,
                      child: TabBar(
                        dividerColor: primaryColor,
                        dividerHeight: 0,
                        unselectedLabelColor: Colors.white.withOpacity(0.6),
                        labelColor: Colors.white,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        tabs: const [
                          Tab(
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.add_comment),
                                Text('Write Feedback')
                              ],
                            ),
                          ),
                          Tab(
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.my_library_books_rounded),
                                Text('Update Feedback')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: BackgroundWithColor(
              child: Container(
                height: ScreenUtil.parentHeight(context) - 90,
                color: const Color.fromARGB(255, 241, 241, 241),
                padding: const EdgeInsets.only(
                  bottom: 16,
                  right: 24,
                  left: 24,
                ),
                child: LayoutBuilder(builder: (context, constraints) {
                  return TabBarView(
                    children: [
                      writeFeedback(constraints, context),
                      UserBasedFeedbacks(
                          onTapWidget: (index) async {
                            final parentContext = context;
                            await _loadFeedback(index);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return EditFeedbackClassInDialog(
                                    starValue: starValue,
                                    selectedFeedback: selectedFeedback,
                                    onEditSuccessful: (text, rateValue) {
                                      feedbackFirestore.updateFeedback(
                                        selectedFeedback['Feedback ID'],
                                        {
                                          "Rating": rateValue,
                                          "Feedback": text,
                                        },
                                      );
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(parentContext)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Updated successfully.')));
                                      setState(() {});
                                    },
                                  );
                                });
                          },
                          futureBuild: _getFeedbacks(),
                          height: constraints.maxHeight - 30)
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadFeedback(int index) async {
    print(feedbacks);
    if (feedbacks.isNotEmpty) {
      setState(() {
        selectedFeedback = feedbacks[index];
        starValue = selectedFeedback['Rating'].toDouble();
        dataLoaded = true;
      });
    }
  }

  Column writeFeedback(
    BoxConstraints constraints,
    BuildContext context,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        LayoutBuilder(builder: (context, constraints) {
          return TextFieldFormat(
            fieldHeight: 50,
            borderRadius: 8,
            fieldWidth: constraints.maxWidth,
            controller: driverNameController,
            formText: 'Driver\'s Name',
          );
        }),
        Row(
          children: [
            TextFieldFormat(
              borderRadius: 8,
              fieldHeight: 60,
              fieldWidth: constraints.maxWidth * 0.5,
              controller: bodyNumberController,
              formText: 'Body Number',
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: UtilityDropDownMenu(
                hintText: 'Zone',
                width: constraints.maxWidth * 0.47,
                dropDownEntries: zoneList,
                textEditingController: zoneController,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50,
          width: constraints.maxWidth,
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            readOnly: true,
            controller: dateController,
            cursorColor: primaryColor,
            textAlign: TextAlign.left,
            maxLines: 5,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                color: primaryColor,
                onPressed: () {
                  _pickDate(context);
                },
                icon: const Icon(Icons.date_range_rounded),
              ),
              label: const Text('Date'),
              labelStyle: const TextStyle(color: primaryColor),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: secondaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: primaryColor,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: primaryColor,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            style: const TextStyle(fontSize: 15),
          ),
        ),
        SizedBox(
          height: constraints.maxHeight * 0.20,
          width: constraints.maxWidth,
          child: TextFormField(
            cursorColor: primaryColor,
            textAlign: TextAlign.left,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Write Something...',
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),
        const Text('Rate your Experience'),
        CustomStarRatingBar(
          starSize: 60,
          initialRating: starValue,
          onRatingUpdate: (value) {
            setState(() {
              starValue = value;
            });
          },
        ),
        PrimaryButton(
          onPressed: () async {
            final instance = FirebaseFirestore.instance;
            final userUID =
                await UserSharedPreferences().readCacheString('UID');
            if (anonymous) {
              await instance
                  .collectionGroup('Vehicle Info')
                  .where('Body Number', isEqualTo: bodyNumberController.text)
                  .where('Zone Number', isEqualTo: zoneController.text)
                  .get()
                  .then((querySnapshot) async {
                if (querySnapshot.docs.isNotEmpty) {
                  final path = querySnapshot.docs.first.reference.path;
                  final docID = path.split('/')[1];

                  final userSnapshot =
                      await instance.collection('Users').doc(docID).get();

                  if (userSnapshot.exists) {
                    final data = userSnapshot.data();
                    if (data != null) {
                      await instance.collection('Feedback').add({
                        "Driver UID": data['UID'],
                        "Date": dateController.text,
                        "Driver Name": data['Full Name'],
                        "Feedback": feedbackTextController.text,
                        "Rating": starValue.toInt(),
                      });
                    }
                  }
                } else {
                  print('No matching document found in Vehicle Info.');
                }
              });
            } else {
              //
              await instance
                  .collectionGroup('Vehicle Info')
                  .where('Body Number', isEqualTo: bodyNumberController.text)
                  .where('Zone Number', isEqualTo: zoneController.text)
                  .get()
                  .then((querySnapshot) async {
                if (querySnapshot.docs.isNotEmpty) {
                  final path = querySnapshot.docs.first.reference.path;
                  final docID = path.split('/')[1];

                  final userSnapshot =
                      await instance.collection('Users').doc(docID).get();

                  if (userSnapshot.exists) {
                    final data = userSnapshot.data();
                    if (data != null) {
                      await instance.collection('Feedback').add({
                        "Driver UID": data['UID'],
                        "Date": dateController.text,
                        "Driver Name": data['Full Name'],
                        "Feedback": feedbackTextController.text,
                        "Rating": starValue.toInt(),
                        "Commuter UID": userUID,
                      });
                    }
                  }
                } else {
                  print('No matching document found in Vehicle Info.');
                }
              });
            }
          },
          buttonText: 'Submit',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoSwitch(
                value: anonymous,
                onChanged: (value) {
                  setState(() {
                    anonymous = value;
                  });
                }),
            const Text('Send Anonymously'),
          ],
        )
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime? picker = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.primary,
                  onPrimary: Theme.of(context).colorScheme.onPrimary,
                  surface: Theme.of(context).colorScheme.surface,
                  onSurface: Theme.of(context).colorScheme.onSurface,
                ),
            datePickerTheme: Theme.of(context).datePickerTheme,
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      fieldLabelText: 'Date in MM/DD/YY',
      fieldHintText: 'Select Date',
      errorFormatText: 'Select Date',
      context: context,
      firstDate: DateTime.utc(2023, 01, 01),
      lastDate: DateTime.utc(2040, 12, 31),
    );

    if (picker != null) {
      dateController.text = picker.toString().split(" ")[0];
    }
  }

  Future<List<Map<String, dynamic>>> _getFeedbacks() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Feedback')
        .where('Commuter UID', isEqualTo: uid)
        .get();
    feedbacks = snapshot.docs.map((e) => e.data()).toList();
    return feedbacks;
  }

  void _getUID() {
    BookingProvider provider =
        Provider.of<BookingProvider>(context, listen: false);
    uid = provider.bookingUserInfo['UID'];
  }
}

class EditFeedbackClassInDialog extends StatefulWidget {
  final void Function(String text, double starVal)? onEditSuccessful;
  final Map<String, dynamic>? selectedFeedback;
  final double starValue;
  final bool enableEdit;
  final double? customHeight;
  final String? customName;
  const EditFeedbackClassInDialog({
    super.key,
    this.onEditSuccessful,
    required this.selectedFeedback,
    this.starValue = 1,
    this.enableEdit = true,
    this.customHeight,
    this.customName,
  });

  @override
  State<EditFeedbackClassInDialog> createState() =>
      _EditFeedbackClassInDialogState();
}

class _EditFeedbackClassInDialogState extends State<EditFeedbackClassInDialog> {
  TextEditingController feedbackTextController = TextEditingController();

  double starValue = 1;
  @override
  void initState() {
    if (widget.selectedFeedback != null) {
      feedbackTextController.text = widget.selectedFeedback!['Feedback'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: widget.customHeight ?? ScreenUtil.parentHeight(context) * 0.7,
          width: ScreenUtil.parentWidth(context) * 0.9,
          child: LayoutBuilder(builder: (context, constraints) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Scaffold(
                appBar: AppBar(
                  title: TextTitle(text: 'Feedback'),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextTitle(
                            fontWeight: FontWeight.w300,
                            text: 'Name: ',
                            fontSize: 16,
                            textColor: grayInputBox,
                          ),
                          TextTitle(
                            textColor: primaryColor,
                            text: widget.customName ??
                                widget.selectedFeedback!['Driver Name']
                                    .toUpperCase(),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextTitle(
                              fontWeight: FontWeight.w300,
                              text: 'Rating:',
                              fontSize: 16,
                              textColor: grayInputBox,
                            ),
                          ),
                          CustomStarRatingBar(
                            starSize: 40,
                            onRatingUpdate: (value) {
                              starValue = value;
                            },
                            initialRating: widget.starValue,
                            ignoreGestures: !widget.enableEdit,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.enableEdit
                              ? 'Update Feedback: '
                              : 'Feedback:'),
                          TextFieldFormat(
                            enabled: widget.enableEdit,
                            borderRadius: 8,
                            fieldHeight: 150,
                            controller: feedbackTextController,
                            maxLines: 5,
                            fieldWidth: constraints.maxWidth - 32,
                          ),
                        ],
                      ),
                      if (widget.enableEdit)
                        SizedBox(
                          width: constraints.maxWidth - 32,
                          child: PrimaryButton(
                            onPressed: () {
                              widget.onEditSuccessful!(
                                  feedbackTextController.text, starValue);
                            },
                            buttonText: 'Confirm',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class UserBasedFeedbacks extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> futureBuild;
  final double height;
  final bool useCommuterName;

  final void Function(int index) onTapWidget;

  UserBasedFeedbacks(
      {super.key,
      required this.futureBuild,
      required this.height,
      required this.onTapWidget,
      this.useCommuterName = false});

  @override
  State<UserBasedFeedbacks> createState() => _UserBasedFeedbacksState();
}

class _UserBasedFeedbacksState extends State<UserBasedFeedbacks> {
  TextEditingController feedbackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextTitle(
            text: 'Feedbacks',
            textColor: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
            height: widget.height,
            child: FutureBuilder<List<Map<String, dynamic>>>(
                future: widget.futureBuild,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData && snapshot.data != null) {
                    return ListView.builder(
                        padding: const EdgeInsets.only(top: 16),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: primaryColor,
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              minVerticalPadding: 10,
                              contentPadding: const EdgeInsets.all(8),
                              iconColor: accentColor,
                              visualDensity: VisualDensity.comfortable,
                              trailing: IconButton(
                                  alignment: Alignment.center,
                                  onPressed: () {},
                                  icon: const Icon(
                                      Icons.arrow_forward_ios_rounded)),
                              title: Text(
                                widget.useCommuterName
                                    ? snapshot.data![index]['Commuter Name']
                                    : "${snapshot.data![index]['Driver Name']}",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Rating',
                                    style: TextStyle(color: grayColor),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: CustomStarRatingBar(
                                          ignoreGestures: true,
                                          onRatingUpdate: (value) {},
                                          initialRating: snapshot.data![index]
                                              ['Rating'])),
                                  const Text(
                                    'Feedback:',
                                    style: TextStyle(color: grayColor),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      '${snapshot.data![index]['Feedback'] != '' ? snapshot.data![index]['Feedback'] : 'No Feedback.'}',
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                widget.onTapWidget(index);
                              },
                            ),
                          );
                        });
                  }
                  return Center(
                    child: Text('No data.'),
                  );
                }),
          )
        ],
      ),
    );
  }
}

class CustomStarRatingBar extends StatelessWidget {
  final double initialRating;
  final bool allowHalfRating;
  final bool ignoreGestures;
  final double starSize;
  final void Function(double value) onRatingUpdate;
  const CustomStarRatingBar(
      {super.key,
      required this.initialRating,
      this.allowHalfRating = false,
      this.ignoreGestures = false,
      this.starSize = 20,
      required this.onRatingUpdate});

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      minRating: 1,
      allowHalfRating: allowHalfRating,
      itemSize: starSize,
      ignoreGestures: ignoreGestures,
      initialRating: initialRating,
      glow: false,
      ratingWidget: RatingWidget(
        full: const Icon(
          Icons.star,
          color: accentColor,
        ),
        half: const Icon(
          Icons.star,
          color: accentColor,
        ),
        empty: const Icon(
          Icons.star,
          color: grayInputBox,
        ),
      ),
      onRatingUpdate: onRatingUpdate,
    );
  }
}

class FeedbackFirestoreComms {
  FirestoreOperations firestoreOperations = FirestoreOperations();

  final firestoreInstance = FirebaseFirestore.instance;
  void addFeedback(Map<String, dynamic> data) {
    final collectionRef = firestoreInstance.collection('Feedback');
    collectionRef.add(data).then((doc) {
      collectionRef.doc(doc.id).update({'Feedback ID': doc.id});
    });
  }

  Future<void> updateFeedback(String id, Map<String, dynamic> data) async {
    final collectionRef = firestoreInstance.collection('Feedback');
    await collectionRef
        .where('Feedback ID', isEqualTo: id)
        .limit(1)
        .get()
        .then((value) {
      final docId = value.docs.first.id;
      collectionRef.doc(docId).update(data);
    });
  }
}
