import 'package:date_count_down/countdown.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/material.dart';

class DateTimeCountDown extends StatefulWidget {
  const DateTimeCountDown({Key? key}) : super(key: key);

  @override
  State<DateTimeCountDown> createState() => _DateTimeCountDownState();
}

class _DateTimeCountDownState extends State<DateTimeCountDown> {
  String countTime = "Loading...";

  @override
  Widget build(BuildContext context) {
    // countTime = CountDown().timeLeft(DateTime.parse("2023-02-10"), "Completed");
    return Scaffold(
      appBar: AppBar(
        title: const Text("CountDown"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Countdown Timer:',
            ),
            CountDownText(
              due: DateTime.utc(2023),
              finishedText: "Done",
              showLabel: true,
              longDateName: true,
              style: TextStyle(color: Colors.blue),
            ),
            Text(
              'Custom Timer',
            ),
            CountDownText(
              due: DateTime.parse("2022-07-19 11:04:06"),
              finishedText: "Done",
              showLabel: true,
              longDateName: true,
              daysTextLong: " DAYS ",
              hoursTextLong: " HOURS ",
              minutesTextLong: " MINUTES ",
              secondsTextLong: " SECONDS ",
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
      ),
    );
  }
}
