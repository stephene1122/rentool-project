import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentool/buildmaterialcolor.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/imageupload/registration_upload_validid.dart';
import 'package:rentool/model/user_model.dart';
import 'package:intl/intl.dart';
import 'package:rentool/screens/agreement_screen.dart';
import 'package:rentool/services/check_token_notification.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key, this.checkBox}) : super(key: key);
  bool? checkBox;
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    // conditions for the value of checkbox
    if (widget.checkBox == true) {
      _checkedValue = true;
    } else {
      _checkedValue = false;
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
      // saveToken(token!);
    });
  }

  final _auth = FirebaseAuth.instance;

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

  String? mtoken;
  String? ctoken;
  bool? _checkedValue;

  // show date picker and format date
  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1990),
        lastDate: new DateTime(2030));
    if (picked != null)
      setState(() => {
            birthDateEditingController.text =
                DateFormat("MM-dd-yyyy").format(picked)
          });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> genderItems = [
      'Male',
      'Female',
    ];

    String? _selectedValue;

    // fullName field
    final fullNameField = TextFormField(
        autofocus: false,
        controller: fullNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Fullname cannot be empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Please enter valid name(Min. 6 Character)");
          }
          return null;
        },
        onSaved: (value) {
          fullNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            prefixIcon: const Icon(Icons.account_circle),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Ex. Rodrigo R. Duterte",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Full Name"));

    // birthDate field
    final birthDateField = TextFormField(
        // focusNode: _focusNode,
        keyboardType: TextInputType.datetime,
        autocorrect: false,
        controller: birthDateEditingController,
        onSaved: (value) {
          birthDateEditingController.text = value!;
        },
        onTap: () {
          _selectDate();
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        maxLines: 1,
        //initialValue: 'Aseem Wangoo',
        validator: (value) {
          if (value!.isEmpty || value.length < 1) {
            return 'Birthdate cannot be empty';
          }
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            hintText: "Month-Day-Year",
            prefixIcon: const Icon(Icons.calendar_month),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Birthdate"));

    // gender field
    final genderField = DropdownButtonFormField2(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
          ),
          prefixIcon: const Icon(Icons.people),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          labelText: "Gender"),
      // icon: const Icon(
      //   Icons.arrow_drop_down,
      //   color: Colors.black45,
      // ),
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 25,
      dropdownPadding: const EdgeInsets.only(left: 20, right: 1),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: genderItems
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Gender cannot be empty';
        }
      },
      onChanged: (String? newValue) {
        // update data when value change
        setState(() {
          genderEditingController.text = newValue.toString();
        });
      },
    );

    // homeAddress field
    final homeAddressField = TextFormField(
        autofocus: false,
        controller: homeAddressEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Home address cannot be empty");
          }
          return null;
        },
        onSaved: (value) {
          homeAddressEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            prefixIcon: const Icon(Icons.home),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
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
        validator: (value) {
          RegExp regex = new RegExp(r'^.{11,}$');
          if (value!.isEmpty) {
            return ("Contact number cannot be empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Please enter valid Contact#(Min. value is 11)");
          }
          return null;
        },
        onSaved: (value) {
          contactNumberEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            prefixIcon: const Icon(Icons.phone_android),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
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
        validator: (value) {
          RegExp regex = new RegExp(r'^.{8,}$');
          if (value!.isEmpty) {
            return ("Email address cannot be empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Please enter valid name(Min. 8 Character)");
          }
          return null;
        },
        onSaved: (value) {
          emailAddressEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(const Color(0xFFC35E12)),
                  width: 2.0),
            ),
            prefixIcon: const Icon(Icons.email),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
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
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password cannot be empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Please enter valid password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(const Color(0xFFC35E12)),
                  width: 2.0),
            ),
            prefixIcon: const Icon(Icons.vpn_key),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
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
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "Password don't match";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(const Color(0xFFC35E12)),
                  width: 2.0),
            ),
            prefixIcon: const Icon(Icons.vpn_key),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
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
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            NotificationToken().checkToken(mtoken!).then((QuerySnapshot d) {
              String token = d.docs[0]['nToken'];
              ctoken = token;
              if (token.isNotEmpty) {
                Fluttertoast.showToast(
                    msg: "This device has already an account.");
              }
            });
            if (_checkedValue == true) {
              singnUpFunction(emailAddressEditingController.text,
                  passwordEditingController.text);
            } else {
              Fluttertoast.showToast(
                  msg: "Please accept our Terms & Conditions!");
            }
          },
          child: const Text(
            "Next",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ));

    // checkBox
    final checkBox = CheckboxListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 1,
      ),
      title: GestureDetector(
        child: Text(
          "Our Terms & Conditions",
          style: GoogleFonts.roboto(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (context) => TermsOfAgreementScreen()));
        },
      ), //    <-- label
      value: _checkedValue,
      onChanged: (d) {
        if (d!) {
          setState(() {
            _checkedValue = d;
          });
          print(_checkedValue);
        } else {
          setState(() {
            _checkedValue = d;
          });
          print(_checkedValue);
        }
      },
      controlAffinity: ListTileControlAffinity.leading,
    );

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
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        fullNameField,
                        const SizedBox(
                          height: 10,
                        ),
                        birthDateField,
                        const SizedBox(
                          height: 10,
                        ),
                        genderField,
                        const SizedBox(
                          height: 10,
                        ),
                        homeAddressField,
                        const SizedBox(
                          height: 10,
                        ),
                        contactNumberField,
                        const SizedBox(
                          height: 10,
                        ),
                        emailAddressField,
                        const SizedBox(
                          height: 10,
                        ),
                        passwordField,
                        const SizedBox(
                          height: 10,
                        ),
                        confirmPasswordField,
                        checkBox,
                        const SizedBox(
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

  void singnUpFunction(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    // writing all the values
    userModel.emailAddress = user!.email;
    userModel.uid = user.uid;
    userModel.fullName = fullNameEditingController.text;
    userModel.birthDate = birthDateEditingController.text;
    userModel.gender = genderEditingController.text;
    userModel.homeAddress = homeAddressEditingController.text;
    userModel.contactNumber = contactNumberEditingController.text;
    userModel.nToken = mtoken;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    // Fluttertoast.showToast(msg: "Account created successfully");
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(
            builder: (context) => UploadValidId(userId: userModel.uid)),
        (route) => false);
  }
}
