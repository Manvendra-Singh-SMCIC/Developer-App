import 'package:flutter/material.dart';

import 'styles.dart';
import 'app_text.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final Color color;
  final double size;
  final double textHeight;

  const ExpandableText(
      {super.key,
      required this.text,
      this.color = grey,
      this.size = 13,
      required this.textHeight});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late String firstHalf;
  late String secondHalf;
  bool hiddenText = true;

  @override
  void initState() {
    double textHeight = widget.textHeight;
    super.initState();

    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf =
          widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? AppText(
              text: firstHalf,
              color: widget.color.withOpacity(0.7),
              size: widget.size,
            )
          : Column(
              children: [
                AppText(
                  text:
                      hiddenText ? ("$firstHalf...") : (firstHalf + secondHalf),
                  color: widget.color.withOpacity(0.7),
                  size: widget.size,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      hiddenText = !hiddenText;
                    });
                  },
                  child: Row(
                    children: [
                      AppText(
                        text: "Show ${hiddenText ? "More" : "Less"}",
                        color: Colors.blue,
                        size: widget.size,
                      ),
                      const SizedBox(width: 20),
                      Icon(
                        hiddenText
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
