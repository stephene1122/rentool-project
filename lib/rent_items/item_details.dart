import 'package:flutter/material.dart';

import '../buildmaterialcolor.dart';

class ItemDetails extends StatefulWidget {
  ItemDetails({Key? key, this.refId}) : super(key: key);

  String? refId;

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  @override
  Widget build(BuildContext context) {
    final itemQuantityField = TextFormField(
        autofocus: false,
        // controller: itemQuantityEditingController,
        keyboardType: TextInputType.number,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Item quantity cannot be empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Please enter value(Min. 6 Character)");
          }
          return null;
        },
        // onSaved: (value) {
        //   itemQuantityEditingController.text = value!;
        // },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Item Quantity"));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Details"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: SizedBox(
                    height: 100,
                    child: Image.asset(
                      "assets/logo.png",
                      fit: BoxFit.contain,
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: buildMaterialColor(const Color(0xFFE3B13B)),
                    border: Border.all(
                        color: buildMaterialColor(const Color(0xFFC35E12))),
                  ),
                  child: Column(
                    children: [
                      _itemField(fieldName: "Item Name"),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: buildMaterialColor(const Color(0xFFE3B13B)),
                          border: Border.all(
                              color:
                                  buildMaterialColor(const Color(0xFFC35E12)),
                              width: 2),
                        ),
                        alignment: Alignment.center,
                        width: 350,
                        height: 130,
                        padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text("Item Description"),
                      ),
                      _itemField(fieldName: "Lender Name"),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              _itemFieldSmall(
                                fieldNameSmall: "Item Photo",
                              ),
                              _itemFieldSmall(
                                fieldNameSmall: "Item Quantity",
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              _itemFieldSmall(
                                fieldNameSmall: "Item Price",
                              ),
                              _itemFieldSmall(
                                fieldNameSmall: "Rent Period",
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: buildMaterialColor(const Color(0xFFC35E12)),
                        ),
                        alignment: Alignment.center,
                        width: 350,
                        margin: EdgeInsets.only(top: 20, bottom: 10),
                        child: MaterialButton(
                          onPressed: () {},
                          child: Text(
                            "Rent Now",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _itemField extends StatelessWidget {
  _itemField({Key? key, this.fieldName}) : super(key: key);

  String? fieldName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: buildMaterialColor(const Color(0xFFE3B13B)),
        border: Border.all(
            color: buildMaterialColor(const Color(0xFFC35E12)), width: 2),
      ),
      alignment: Alignment.center,
      width: 350,
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      margin: EdgeInsets.only(
        top: 10,
      ),
      child: Text("${fieldName}"),
    );
  }
}

class _itemFieldSmall extends StatelessWidget {
  _itemFieldSmall({Key? key, this.fieldNameSmall}) : super(key: key);
  String? fieldNameSmall;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: buildMaterialColor(const Color(0xFFE3B13B)),
        border: Border.all(
            color: buildMaterialColor(const Color(0xFFC35E12)), width: 2),
      ),
      alignment: Alignment.center,
      width: 150,
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      margin: EdgeInsets.only(
        top: 10,
      ),
      child: Text("${fieldNameSmall}"),
    );
  }
}
