import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/commuter/commuter_screen/mainScreenWithMap.dart';
import 'package:intl/intl.dart';

import '../constants/constants.dart';
import '../constants/screenSizes.dart';
import '../constants/titleText.dart';

class DbTableStream extends StatelessWidget {
  final Stream<List<Map<String, dynamic>>>? stream;
  final List<String> columnHeader;
  final List<String> titles;
  final String tableInfoTitle;
  final bool useCustomWidget;
  final bool requestEdit;
  final List<PopupMenuEntry> Function(Map<String, dynamic> snapshot)?
      overlayActions;
  DbTableStream(
      {super.key,
      required this.stream,
      required this.columnHeader,
      required this.tableInfoTitle,
      required this.titles,
      this.overlayActions,
      this.useCustomWidget = false,
      this.requestEdit = true});
  final GlobalKey menuButtonKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              alignment: Alignment.center,
              height: ScreenUtil.parentHeight(context) * 0.8,
              child: const Center(
                child: CircularProgressIndicator(
                  color: accentColor,
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error retrieving data. ${snapshot.error}'),
            );
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final firstEntry = '${snapshot.data![0][columnHeader[0]]}';

            // userEntryValues = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: ScreenUtil.parentHeight(context),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: firstEntry.isEmpty ? 80 : 30,
                    columns: List.generate(titles.length, (columnIndex) {
                      return DataColumn(
                          label: TextTitle(
                        text: titles[columnIndex],
                        fontSize: 12,
                      ));
                    }),
                    rows: List.generate(snapshot.data!.length, (rowIndex) {
                      return DataRow(
                          onLongPress: () {
                            showOverlayDialog(
                                rowIndex, context, snapshot.data!);
                          },
                          cells: [
                            DataCell(
                              SizedBox(
                                width: 90,
                                child: Badge(
                                  backgroundColor: (snapshot.data![rowIndex]
                                                  ['Request Edit'] ??
                                              '') ==
                                          'Pending'
                                      ? secondaryColor
                                      : Colors.transparent,
                                  child: TextTitle(
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    text:
                                        '${snapshot.data![rowIndex][titles[0]] ?? 'N/A'}',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 90,
                                child: TextTitle(
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  text:
                                      '${snapshot.data![rowIndex][titles[1]] ?? 'N/A'}',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            if (titles.length > 3)
                              DataCell(
                                SizedBox(
                                  width: 90,
                                  child: TextTitle(
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    text:
                                        '${snapshot.data![rowIndex][titles[2]] ?? 'N/A'}',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            DataCell(TextButton(
                                style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                    foregroundColor:
                                        const WidgetStatePropertyAll(
                                            Colors.white),
                                    backgroundColor:
                                        const WidgetStatePropertyAll(
                                            accentColor)),
                                onPressed: () {
                                  showOverlayDialog(
                                      rowIndex, context, snapshot.data!);
                                },
                                child: const Text('Details'))),
                          ]);
                    }),
                  ),
                ),
              ),
            );
          }
          return Container(
            alignment: Alignment.center,
            height: ScreenUtil.parentHeight(context) * 0.8,
            child: const Text(
              'No data.',
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  void showOverlayDialog(int userIndex, BuildContext context,
      List<Map<String, dynamic>> snapshot) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
              decoration: BoxDecoration(
                  color: adminGradientColor2,
                  borderRadius: BorderRadius.circular(8)),
              height: ScreenUtil.parentHeight(context) * 0.90,
              width: ScreenUtil.parentWidth(context) * 0.90,
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  children: [
                    AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: adminGradientColor1,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      )),
                      leading: overlayActions != null
                          ? Badge(
                              alignment: Alignment.topLeft,
                              backgroundColor:
                                  (snapshot[userIndex]['Request Edit'] ?? '') ==
                                          'Pending'
                                      ? secondaryColor
                                      : Colors.transparent,
                              child: IconButton(
                                  key: menuButtonKey,
                                  color: softWhite,
                                  onPressed: () {
                                    final renderBox = menuButtonKey
                                        .currentContext!
                                        .findRenderObject() as RenderBox;
                                    final position =
                                        renderBox.localToGlobal(Offset.zero);
                                    showMenu(
                                        context: context,
                                        position: RelativeRect.fromLTRB(
                                            0,
                                            position.dy + renderBox.size.height,
                                            position.dx,
                                            0),
                                        items: overlayActions!(
                                            snapshot[userIndex]));
                                  },
                                  icon: const Icon(Icons.menu)),
                            )
                          : null,
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.close,
                            color: accentColor,
                          ),
                        ),
                      ],
                      centerTitle: true,
                      title: TextTitle(
                        text: tableInfoTitle,
                        fontSize: 18,
                      ),
                    ),
                    const Divider(
                      color: adminGradientColor1,
                      thickness: 0.5,
                    ),
                    SizedBox(
                      width: constraints.maxWidth * 0.90,
                      height: constraints.maxHeight * 0.85,
                      child: Column(
                        children: [
                          if (useCustomWidget)
                            UserProfileAdmin(
                              data: snapshot[userIndex],
                            ),
                          SizedBox(
                            width: constraints.maxWidth * 0.90,
                            height: useCustomWidget
                                ? constraints.maxHeight * 0.5
                                : constraints.maxHeight * 0.85,
                            child: Scrollbar(
                              child: GridView.count(
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 8,
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  children: List.generate(columnHeader.length,
                                      (valueIndex) {
                                    final filteredValues =
                                        snapshot.map((entry) {
                                      return {
                                        for (var key in columnHeader)
                                          key: entry.containsKey(key)
                                              ? entry[key]
                                              : 'N/A',
                                      };
                                    }).toList();
                                    var value;

                                    String currentKey =
                                        filteredValues[userIndex]
                                            .keys
                                            .toList()[valueIndex];

                                    if (filteredValues[userIndex][currentKey]
                                        is Timestamp) {
                                      value = _getDateInTimeStamp(
                                          excludeTime:
                                              currentKey == 'License Expiry',
                                          filteredValues[userIndex]
                                              [currentKey]);
                                    } else {
                                      value = filteredValues[userIndex]
                                                  [currentKey]
                                              ?.toString() ??
                                          'N/A';
                                    }

                                    return Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                  color: adminGradientColor1,
                                                  width: 0.5)),
                                          height: 120,
                                          width: 140,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  columnHeader[valueIndex],
                                                  style: const TextStyle(
                                                    color: accentColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  '${value.isNotEmpty && value != null ? value : 'N/A'}',
                                                  style: const TextStyle(
                                                    color: softWhite,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  })),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              })),
        );
      },
    );
  }

  String _getDateInTimeStamp(Timestamp data, {bool excludeTime = false}) {
    final timestamp = data;
    if (excludeTime) {
      return '${DateFormat.yMd('en_US').format(timestamp.toDate())}';
    } else {
      return '${DateFormat.jm().format(timestamp.toDate())} ${DateFormat.yMd('en_US').format(timestamp.toDate())}';
    }
  }
}

class UserProfileAdmin extends StatelessWidget {
  final Map<String, dynamic> data;

  UserProfileAdmin({
    super.key,
    required this.data,
  });
  final GetPhotoLinkOfUser getPhoto = GetPhotoLinkOfUser();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<String?>(
              future: _getPhoto(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  const CircleAvatar(
                      radius: 48,
                      child: CircularProgressIndicator(
                        color: accentColor,
                      ));
                }
                if (snapshot.hasData && snapshot.data != null) {
                  return CircleAvatar(
                    foregroundImage: CachedNetworkImageProvider(snapshot.data!),
                    backgroundColor: accentColor,
                    radius: 48,
                    child: const Icon(
                      Icons.person,
                      size: 48,
                    ),
                  );
                }
                return const CircleAvatar(
                  backgroundColor: accentColor,
                  radius: 48,
                  child: Icon(
                    Icons.person,
                    size: 48,
                  ),
                );
              }),
        ),
        Column(
          children: [
            TextTitle(text: '${data['Full Name']}'),
            Text(
              '${data['Contact Number']}',
              style: const TextStyle(color: accentColor),
            ),
            const Divider(
              thickness: 0.2,
              indent: 16,
              endIndent: 16,
            ),
          ],
        ),
      ],
    );
  }

  Future<String?> _getPhoto() async {
    final photo = await getPhoto.getPhotoLink(data['UID']);
    print(photo);
    return photo;
  }
}
