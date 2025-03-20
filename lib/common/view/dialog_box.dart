
import 'package:cashmore_app/common/constants.dart';
import 'package:flutter/material.dart';

class DialogBoxAction {
  final String text;
  final Color? bgColor;
  final Color? textColor;
  final VoidCallback? onClick;

  DialogBoxAction({
    required this.text,
    this.bgColor,
    this.textColor,
    this.onClick
  });
}

class DialogBox extends StatefulWidget {
  final String title;
  final Widget descriptions;
  final List<DialogBoxAction> actions;
  final EdgeInsets? padding;
  final AlignmentGeometry? alignment;

  const DialogBox({
    Key? key,
    required this.title,
    required this.descriptions,
    required this.actions,
    this.padding,
    this.alignment,
  }) : super(key: key);

  @override
  DialogBoxState createState() => DialogBoxState();
}

class DialogBoxState extends State<DialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      insetPadding: widget.padding,
      alignment: widget.alignment,
      elevation: 0,
      child: drawDialog(context),
    );
  }

  Widget drawDialog(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.title,
                  style: const TextStyle(
                      color: sdGray9,
                      fontSize: 17,
                      fontWeight: FontWeight.w800)),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 80,
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 16, left: 10, right: 10),
                  alignment: Alignment.center,
                  child: widget.descriptions,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  children: widget.actions.map((a) => drawButton(a)).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget drawButton(DialogBoxAction action) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: 52,
        child: ElevatedButton(
          onPressed: action.onClick??()=>{},
          style: ElevatedButton.styleFrom(
            backgroundColor: action.bgColor??sdGray5,
            shape: const ContinuousRectangleBorder(),
            elevation: 0,
          ),
          child: Text(
            action.text,
            style: TextStyle(
                color: action.textColor??sdGray0,
                fontSize: 16,
                fontWeight: FontWeight.w600
            )
          ),
        ),
      ),
    );
  }
}
