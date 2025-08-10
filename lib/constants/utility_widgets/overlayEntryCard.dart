import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';

class OverlayEntryCard extends StatefulWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final List<Widget>? actions;
  final String? titleText;
  final Widget? child;
  final VoidCallback? onDismiss;
  final AnimationController? animationController;
  final bool dismissable;
  final bool enableBackButton;
  const OverlayEntryCard({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.actions,
    this.titleText,
    this.child,
    this.onDismiss,
    this.animationController,
    this.dismissable = true,
    this.enableBackButton = true,
  });

  @override
  State<OverlayEntryCard> createState() => _OverlayEntryCardState();
}

class _OverlayEntryCardState extends State<OverlayEntryCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ModalBarrier(
          color: Colors.black26,
          dismissible: widget.dismissable,
          onDismiss: widget.onDismiss,
        ),
        FadeTransition(
          opacity: CurvedAnimation(
              parent: widget.animationController!, curve: Curves.easeIn),
          child: Container(
            height: widget.height,
            width: widget.width,
            alignment: Alignment.center,
            child: Card(
              child: LayoutBuilder(builder: (context, constraints) {
                return Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    automaticallyImplyLeading: widget.enableBackButton,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8))),
                    title: TextTitle(
                      text: widget.titleText!,
                      fontSize: 16,
                    ),
                    actions: widget.actions,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: widget.child,
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
