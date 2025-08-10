import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/textFields.dart';
import 'package:flutter_try_thesis/drawer_pages/unsavedChangesNotifier.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/userSharedPreferences.dart';
import 'package:flutter_try_thesis/models/uploadImage.dart';
import 'package:provider/provider.dart';

class AdminAccountSettings extends StatefulWidget {
  const AdminAccountSettings({super.key});

  @override
  State<AdminAccountSettings> createState() => _AdminAccountSettingsState();
}

class _AdminAccountSettingsState extends State<AdminAccountSettings> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late UnsavedChangesNotifier provider;
  String? uid;
  Timer? debounce;
  String photoPath = '';

  String id = '';

  @override
  void initState() {
    provider = Provider.of<UnsavedChangesNotifier>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          appBarTheme: AppBarTheme(
              iconTheme: const IconThemeData(color: softWhite),
              backgroundColor: adminGradientColor3,
              titleTextStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: softWhite))),
      child: Scaffold(
        floatingActionButton:
            Consumer<UnsavedChangesNotifier>(builder: (context, provider, _) {
          return provider.unsavedChanges
              ? FloatingActionButton(
                  backgroundColor: accentColor,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    if (debounce?.isActive ?? false) {
                      debounce?.cancel();
                    }
                    debounce =
                        Timer(const Duration(milliseconds: 500), () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: accentColor,
                              ),
                            );
                          });
                      FocusScope.of(context).unfocus();
                      if (provider.image != null) {
                        await uploadImage();
                      }
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(id)
                          .update({
                        "Photo Link": photoPath,
                        "Hash": passwordController.text,
                      });

                      provider.unsaved(false);
                      Navigator.of(context).pop();
                    });
                  })
              : const SizedBox.shrink();
        }),
        appBar: AppBar(
          title: const Text(
            'Account Settings',
          ),
        ),
        backgroundColor: adminGradientColor1,
        body: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
              future: _getAdminAccount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: accentColor,
                    ),
                  );
                }
                if (snapshot.hasData && snapshot.data != null) {
                  usernameController.text = snapshot.data!['Username'];
                  passwordController.text = snapshot.data!['Hash'];
                  return Consumer<UnsavedChangesNotifier>(
                      builder: (context, provider, _) {
                    return Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: TextTitle(
                            text: 'User Profile',
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            child: Stack(
                              children: [
                                if (photoPath.isNotEmpty &&
                                    provider.image == null)
                                  CircleAvatar(
                                    backgroundColor: accentColor,
                                    foregroundImage:
                                        CachedNetworkImageProvider(photoPath),
                                    radius: 54,
                                    child: const Icon(
                                      Icons.person,
                                      size: 48,
                                    ),
                                  )
                                else
                                  CircleAvatar(
                                    backgroundColor: accentColor,
                                    foregroundImage: provider.image != null
                                        ? FileImage(File(provider.image!.path))
                                        : null,
                                    radius: 54,
                                    child: const Icon(
                                      Icons.person,
                                      size: 48,
                                    ),
                                  ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: IconButton(
                                    style: const ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            adminGradientColor3)),
                                    onPressed: () async {
                                      provider.image =
                                          await ImageUpload().selectImage();
                                      if (provider.image != null) {
                                        provider.unsaved(true);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: softWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextTitle(
                                text: 'Username',
                                fontSize: 14,
                              ),
                              TextFieldFormat(
                                disabledColor: accentColor,
                                textColor: softWhite,
                                borderRadius: 8,
                                enabled: false,
                                controller: usernameController,
                                fieldHeight: 65,
                                fieldWidth: 260,
                                borderColor: accentColor,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextTitle(
                                text: 'Password',
                                fontSize: 14,
                              ),
                              TextFieldFormat(
                                hintText: "Password",
                                enableObscure: true,
                                onChanged: (str) {
                                  // if (str == passwordController.text) {
                                  provider.unsaved(true);
                                  // }
                                },
                                textColor: softWhite,
                                borderRadius: 8,
                                controller: passwordController,
                                fieldHeight: 65,
                                fieldWidth: 260,
                                borderColor: accentColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  });
                }
                return const Center(
                  child: TextTitle(text: 'No data.'),
                );
              }),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _getAdminAccount() async {
    // uid = await UserSharedPreferences().readCacheString('Admin UID');
    // final user = await FirebaseFirestore.instance
    //     .collection('Users')
    //     .where('UID', isEqualTo: uid)
    //     .where('Role', isEqualTo: 'Admin')
    //     .limit(1)
    //     .get();
    Map<String, dynamic> data = {};
    // final data = user.docs.first.data();
    // id = user.docs.first.id;
    try {
      id = await UserSharedPreferences().readCacheString("Admin Doc") ?? '';
      final user =
          await FirebaseFirestore.instance.collection('Users').doc(id).get();
      data = user.data()!;
    } catch (e) {
      print('Failed to fetch user: $e');
    }
    if (data['Photo Link'] != null) {
      photoPath = data['Photo Link'];
      print(photoPath);
    }
    return data;
  }

  Future<void> uploadImage() async {
    await ImageUpload().uploadImageToFirebase(
        provider.image!, 'userUploads/$uid', (uploadTask, url) {
      photoPath = url;
    }, () {});
  }
}
