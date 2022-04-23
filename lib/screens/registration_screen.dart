import 'package:flutter/material.dart';
import 'package:rentool/buildmaterialcolor.dart';
import 'package:hexcolor/hexcolor.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing controller
  final fullNameEditingController = new TextEditingController();
  final birthDateEditingController = new TextEditingController();
  final genderEditingController = new TextEditingController();
  final homeAddressEditingController = new TextEditingController();
  final contactNumberEditingController = new TextEditingController();
  final emailAddressEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // fullName field
    final fullNameField = TextFormField(
        autofocus: false,
        controller: fullNameEditingController,
        keyboardType: TextInputType.name,
        //validator: (){},
        onSaved: (value) {
          fullNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            prefixIcon: Icon(Icons.account_circle),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Ex. Rodrigo R. Duterte",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Full Name"));

    // birthDate field
    final birthDateField = TextFormField(
        autofocus: false,
        controller: birthDateEditingController,
        keyboardType: TextInputType.datetime,
        //validator: (){},
        onSaved: (value) {
          birthDateEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            prefixIcon: Icon(Icons.calendar_month),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Month/Day/Year",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Birthdate"));

    // gender field
    final genderField = TextFormField(
        autofocus: false,
        controller: genderEditingController,
        keyboardType: TextInputType.name,
        //validator: (){},
        onSaved: (value) {
          genderEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            prefixIcon: Icon(Icons.people),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Male / Female",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Gender"));

    // homeAddress field
    final homeAddressField = TextFormField(
        autofocus: false,
        controller: homeAddressEditingController,
        keyboardType: TextInputType.emailAddress,
        //validator: (){},
        onSaved: (value) {
          homeAddressEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            prefixIcon: Icon(Icons.home),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Ex. Purok 1, Salvacion Panabo City",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Home Address"));

    // contactNumber field
    final contactNumberField = TextFormField(
        autofocus: false,
        controller: contactNumberEditingController,
        keyboardType: TextInputType.phone,
        //validator: (){},
        onSaved: (value) {
          contactNumberEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            prefixIcon: Icon(Icons.phone_android),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Ex. 09127010539",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Contact Number"));

    //  emailAddress field
    final emailAddressField = TextFormField(
        autofocus: false,
        controller: emailAddressEditingController,
        keyboardType: TextInputType.emailAddress,
        //validator: (){},
        onSaved: (value) {
          emailAddressEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            prefixIcon: Icon(Icons.email),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Ex. rodrigoduterte@gmail.com",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Email Address"));

    // password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        //validator: (){},
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            prefixIcon: Icon(Icons.vpn_key),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            // hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Password"));

    // confirmPassword field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,
        //validator: (){},
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            prefixIcon: Icon(Icons.vpn_key),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Re-enter your password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Confirm Password"));

    // next button
    final nextBtn = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(6),
        color: HexColor("#C35E12"),
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {},
          child: Text(
            "Next",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ));

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: HexColor("#C35E12"),
                ),
                // passing this to our root
                onPressed: () {
                  Navigator.of(context).pop();
                })),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.topCenter,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 120,
                          child: Image.asset(
                            "assets/logo.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        fullNameField,
                        SizedBox(
                          height: 10,
                        ),
                        birthDateField,
                        SizedBox(
                          height: 10,
                        ),
                        genderField,
                        SizedBox(
                          height: 10,
                        ),
                        homeAddressField,
                        SizedBox(
                          height: 10,
                        ),
                        contactNumberField,
                        SizedBox(
                          height: 10,
                        ),
                        emailAddressField,
                        SizedBox(
                          height: 10,
                        ),
                        passwordField,
                        SizedBox(
                          height: 10,
                        ),
                        confirmPasswordField,
                        SizedBox(
                          height: 25,
                        ),
                        nextBtn,
                      ],
                    )),
              ),
            ),
          ),
        ));
  }
}
