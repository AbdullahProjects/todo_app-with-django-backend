import 'package:flutter/material.dart';
import 'package:frontend/common_widgets.dart/text_style.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/consts.dart';

class ShowTodo extends StatelessWidget {
  final String title;
  final String desc;
  final bool isDone;
  final String date;
  const ShowTodo(
      {super.key,
      required this.title,
      required this.date,
      required this.desc,
      required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: boldText(text: "Todo Detail", size: 18.0, color: purpleColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: normalText(
                  text: date.substring(0, 10),
                  color: lightBlackColor,
                ),
              ),
            ),
            5.heightBox,
            boldText(text: title, color: blackColor, size: 22.0),
            10.heightBox,
            normalText(text: desc, color: lightBlackColor),
            10.heightBox,
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: context.screenWidth,
        height: 60,
        color: isDone ? greenColor : redColor,
        child: Center(
          child: isDone
              ? normalText(text: "Done", color: whiteColor, size: 16.0)
              : normalText(text: "Incomplete", color: whiteColor, size: 16.0),
        ),
      ),
    );
  }
}
