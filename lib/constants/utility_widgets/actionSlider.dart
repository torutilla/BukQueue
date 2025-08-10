import 'package:action_slider/action_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../screenSizes.dart';

class CustomActionSlider extends StatelessWidget {
  final Function(ActionSliderController controller) callBack;
  final void Function(ActionSliderController controller)? whileLoading;
  final void Function()? onError;
  final String sliderText;
  const CustomActionSlider(
      {super.key,
      required this.callBack,
      this.whileLoading,
      this.onError,
      this.sliderText = 'Slide to accept booking'});

  @override
  Widget build(BuildContext context) {
    return ActionSlider.standard(
      actionThresholdType: ThresholdType.release,
      icon: const Icon(Icons.keyboard_double_arrow_right_rounded),
      loadingIcon: const CircularProgressIndicator(
        color: softWhite,
      ),
      failureIcon: Icon(Icons.close),
      successIcon: const Icon(Icons.check),
      width: (ScreenUtil.parentWidth(context) * 0.90) - 40,
      height: 60,
      action: (controller) async {
        controller.loading();
        whileLoading!(controller);
        await Future.delayed(const Duration(seconds: 6));
        await Future.delayed(const Duration(milliseconds: 500), () async {
          callBack(controller);
          controller.success();
        });
      },
      child: Text(sliderText,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontWeight: FontWeight.w500)),
    );
    ;
  }
}
