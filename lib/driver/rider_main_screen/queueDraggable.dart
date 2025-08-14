import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/models/providers/bookingProvider.dart';
import 'package:provider/provider.dart';

class QueueDraggable extends StatelessWidget {
  const QueueDraggable({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        controller: queueDraggable,
        initialChildSize: 0,
        minChildSize: 0,
        maxChildSize: 0.8,
        builder: (context, controller) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              controller: controller,
              child: SizedBox(
                height: ScreenUtil.parentHeight(context) * 0.6,
                child: Consumer<BookingProvider>(
                    builder: (context, provider, child) {
                  return LayoutBuilder(builder: (context, constraints) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80,
                                height: 5,
                                decoration: BoxDecoration(
                                    color: grayColor,
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              // SvgPicture.asset(
                              //   'assets/images/Bukyo.svg',
                              //   height: 80,
                              //   colorFilter: const ColorFilter.mode(
                              //       primaryColor, BlendMode.srcIn),
                              // ),
                              Column(
                                children: [
                                  const TextTitle(
                                    text: 'Join Queue',
                                    textColor: blackColor,
                                  ),
                                  Text(
                                      '${provider.bookingUserInfo['Zone Number']}: ${provider.currentTerminal}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // StreamBuilder(
                        //     stream: queueListener(),
                        //     builder: (_, snapshot) {
                        //       if (snapshot.connectionState ==
                        //           ConnectionState.waiting) {
                        //         return SizedBox(
                        //           height: constraints.maxHeight * 0.4,
                        //           child: const Column(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               CircularProgressIndicator(),
                        //               Text('Calculating your position...'),
                        //             ],
                        //           ),
                        //         );
                        //       }
                        //       if (startQueueListener) {
                        //         if (snapshot.data == 0) {
                        //           queueTimer =
                        //               Timer(const Duration(seconds: 2), () {
                        //             Future.delayed(Duration(milliseconds: 500));
                        //             if (isTimerActive && snapshot.data == 0) {
                        //               controlDraggable(queueDraggable, 0,
                        //                   Curves.easeOutCubic);
                        //               Future.delayed(
                        //                   const Duration(seconds: 1));
                        //               controlDraggable(draggableController, 1,
                        //                   Curves.easeInCubic);
                        //               provider.listenToBookingDatabaseValues();
                        //               setState(() {
                        //                 startQueueListener = false;
                        //                 enableQueueDraggable = false;
                        //               });
                        //             }
                        //           });
                        //           return SizedBox(
                        //             height: constraints.maxHeight * 0.4,
                        //             child: const Center(
                        //               child: Text(
                        //                   'You are next in line. Please wait...'),
                        //             ),
                        //           );
                        //         }
                        //         if (snapshot.data != null) {
                        //           return SizedBox(
                        //             height: constraints.maxHeight * 0.4,
                        //             child: Column(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 Text(
                        //                   'Your position in queue:',
                        //                   style: Theme.of(context)
                        //                       .textTheme
                        //                       .titleMedium!
                        //                       .copyWith(
                        //                           color: accentColor,
                        //                           fontWeight: FontWeight.w700),
                        //                 ),
                        //                 TextTitle(
                        //                   text: '${snapshot.data!}',
                        //                   textColor: blackColor,
                        //                   fontSize: 120,
                        //                 ),
                        //               ],
                        //             ),
                        //           );
                        //         }
                        //       }
                        //       return SizedBox(
                        //         height: constraints.maxHeight * 0.4,
                        //         child: Column(
                        //           children: [
                        //             Text(
                        //               'Drivers in Queue:',
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .titleMedium!
                        //                   .copyWith(
                        //                       color: accentColor,
                        //                       fontWeight: FontWeight.w700),
                        //             ),
                        //             TextTitle(
                        //               text: '${snapshot.data /*?? 0*/}',
                        //               textColor: blackColor,
                        //               fontSize: 120,
                        //             ),
                        //           ],
                        //         ),
                        //       );
                        //     }),
                        StreamBuilder<int>(
                          stream: queueListener(),
                          builder: (_, snapshot) {
                            final queuePosition = snapshot.data ?? -1;

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                height: constraints.maxHeight * 0.4,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                    Text('Calculating your position...'),
                                  ],
                                ),
                              );
                            }
                            if (queuePosition != 0) {
                              if (queueTimer?.isActive ?? false) {
                                queueTimer?.cancel();
                              }
                            }

                            if (startQueueListener && queuePosition == 0) {
                              if (isTimerActive) {
                                queueTimer?.cancel();
                              }
                              queueTimer =
                                  Timer(const Duration(seconds: 2), () {
                                if (isTimerActive && queuePosition == 0) {
                                  controlDraggable(
                                      queueDraggable, 0, Curves.easeOutCubic);
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    controlDraggable(draggableController, 1,
                                        Curves.easeInCubic);
                                  });

                                  provider.listenToBookingDatabaseValues();

                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    setState(() {
                                      startQueueListener = false;
                                      enableQueueDraggable = false;
                                    });
                                  });
                                } else {
                                  return;
                                }
                              });

                              return SizedBox(
                                height: constraints.maxHeight * 0.4,
                                child: const Center(
                                  child: Text(
                                      'You are next in line. Please wait...'),
                                ),
                              );
                            }

                            return SizedBox(
                              height: constraints.maxHeight * 0.4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    startQueueListener
                                        ? 'Your position in queue:'
                                        : 'Drivers in Queue:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            color: accentColor,
                                            fontWeight: FontWeight.w700),
                                  ),
                                  TextTitle(
                                    text:
                                        '${queuePosition >= 0 ? queuePosition : 0}',
                                    textColor: blackColor,
                                    fontSize: 120,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: PrimaryButton(
                              backgroundColor: startQueueListener
                                  ? Colors.white
                                  : primaryColor,
                              buttonText: startQueueListener
                                  ? 'Cancel Queue'
                                  : 'Enter Queue',
                              borderColor:
                                  startQueueListener ? primaryColor : null,
                              textColor:
                                  startQueueListener ? primaryColor : softWhite,
                              onPressed: () {
                                if (startQueueListener) {
                                  isTimerActive = false;
                                  // queueTimer!.cancel();
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          actionsAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          actions: [
                                            PrimaryButton(
                                              onPressed: () {
                                                if (queueTimer != null &&
                                                    queueTimer!.isActive) {
                                                  queueTimer!.cancel();
                                                  print('Queue Timer canceled');
                                                }
                                                dequeuePosition();
                                                setState(() {
                                                  startQueueListener = false;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              buttonText: 'Yes',
                                              backgroundColor: grayInputBox,
                                              textColor: blackColor,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: PrimaryButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isTimerActive = true;
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                buttonText: 'No',
                                                backgroundColor: errorColor,
                                              ),
                                            ),
                                          ],
                                          title: const Text('Cancel Queueing?'),
                                          content: const Text(
                                              'Do you want to cancel your queue and leave your current spot?'),
                                          icon: const Icon(
                                            Icons.warning,
                                            size: 48,
                                          ),
                                          iconColor: errorColor,
                                        );
                                      });
                                } else {
                                  queueListener();
                                  enqueuePosition();
                                  setState(() {
                                    startQueueListener = true;
                                    isTimerActive = true;
                                  });
                                }
                              }),
                        ),
                      ],
                    );
                  });
                }),
              ),
            ),
          );
        });
  }
}
