import 'package:flutter/material.dart';

class RentDetails extends StatefulWidget {
  RentDetails({Key? key, this.refId}) : super(key: key);
  String? refId;
  @override
  State<RentDetails> createState() => _RentDetailsState();
}

class _RentDetailsState extends State<RentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rent Details"),
      ),
    );
  }
}
