import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/textFields.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';

class AddVehicleType extends StatefulWidget {
  const AddVehicleType({super.key});

  @override
  State<AddVehicleType> createState() => _AddVehicleTypeState();
}

class _AddVehicleTypeState extends State<AddVehicleType> {
  int vehiclesLength = 0;

  TextEditingController vehicleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          vehicleController.text = '';
          showDialog(
            context: context,
            builder: (context) {
              return addVehicleDialog();
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: accentColor,
        shape: CircleBorder(),
        tooltip: 'Add vehicle',
      ),
      appBar: AppBar(
        backgroundColor: adminGradientColor4,
        title: Text(
          'Manage Vehicle types',
          style: TextStyle(color: softWhite, fontSize: 24),
        ),
      ),
      backgroundColor: adminGradientColor2,
      body: FutureBuilder<Map<String, dynamic>?>(
          future: fetchVehicleTypes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: accentColor,
                ),
              );
            }
            if (snapshot.hasError || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No data',
                  style: TextStyle(color: softWhite),
                ),
              );
            }

            return Container(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                height: ScreenUtil.parentHeight(context) * 0.8,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final values = snapshot.data!.values.elementAt(index);
                    final keys = snapshot.data!.keys.elementAt(index);
                    return Dismissible(
                      background: Container(
                        padding: EdgeInsets.all(8),
                        color: primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.edit, color: Colors.white, size: 30),
                            SizedBox(width: 8),
                            Text(
                              "Edit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      secondaryBackground: Container(
                        padding: EdgeInsets.all(8),
                        color: errorColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.delete, color: Colors.white, size: 30),
                            SizedBox(width: 8),
                            Text(
                              "Delete",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      key: Key(keys),
                      direction: DismissDirection.horizontal,
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          vehicleController.text = values;
                          showDialog(
                              context: context,
                              builder: (context) {
                                return addVehicleDialog(
                                    isEditing: true, key: keys);
                              });
                          return false;
                        }
                        return true;
                      },
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          FirebaseFirestore.instance
                              .collection('Vehicle_Types')
                              .doc('Vehicles')
                              .update({keys: FieldValue.delete()});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Vehicle deleted")),
                          );
                          setState(() {});
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: softWhite, width: 0.5)),
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextTitle(
                                textAlign: TextAlign.left,
                                text: 'Vehicle:',
                                fontWeight: FontWeight.w100,
                                fontSize: 24,
                              ),
                              TextTitle(
                                textColor: accentColor,
                                textAlign: TextAlign.left,
                                text: values,
                                fontSize: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
    );
  }

  Future<Map<String, dynamic>?> fetchVehicleTypes() async {
    final vehicleRef = await FirebaseFirestore.instance
        .collection('Vehicle_Types')
        .doc('Vehicles')
        .get();
    vehiclesLength = vehicleRef.data()!.length;
    return vehicleRef.data();
  }

  void addVehicleType(String newVehicleName,
      {bool isEditing = false, String? key}) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Vehicle_Types').doc('Vehicles');

    try {
      if (isEditing) {
        await docRef.update({key!: newVehicleName});
        return;
      }
      DocumentSnapshot snapshot = await docRef.get();
      if (!snapshot.exists) {
        await docRef.set({"Vehicle type 1": newVehicleName});
        return;
      }

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      List<int> existingNumbers = [];
      data.keys.forEach((key) {
        RegExp regExp = RegExp(r'(\d+)');
        Match? match = regExp.firstMatch(key);
        if (match != null) {
          existingNumbers.add(int.parse(match.group(0)!));
        }
      });

      int newNumber = 1;
      existingNumbers.sort();
      for (int i = 0; i < existingNumbers.length; i++) {
        if (existingNumbers[i] != i + 1) {
          newNumber = i + 1;
          break;
        } else {
          newNumber = existingNumbers.length + 1;
        }
      }

      await docRef.update({
        "Vehicle type $newNumber": newVehicleName,
      });
      setState(() {});
    } catch (e) {
      print("Error adding vehicle: $e");
    }
  }

  Widget addVehicleDialog({bool isEditing = false, String? key}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: adminGradientColor3,
              borderRadius: BorderRadius.circular(8),
            ),
            height: 200,
            width: ScreenUtil.parentWidth(context) * 0.85,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextTitle(
                          text: isEditing ? 'Edit Vehicle' : 'Add Vehicle'),
                      SizedBox(
                        width: constraints.maxWidth * 0.95,
                        child: TextFieldFormat(
                          backgroundColor: softWhite,
                          controller: vehicleController,
                          borderColor: const Color.fromARGB(255, 42, 58, 87),
                          focusedBorderColor: accentColor,
                          borderRadius: 8,
                        ),
                      ),
                      PrimaryButton(
                        buttonText: 'Confirm',
                        onPressed: () {
                          if (vehicleController.text.isNotEmpty) {
                            addVehicleType(vehicleController.text,
                                isEditing: isEditing, key: key);
                            Navigator.of(context).pop();
                          }
                        },
                        backgroundColor: accentColor,
                        onPressedColor: adminGradientColor4,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
