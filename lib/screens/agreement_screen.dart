import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rentool/screens/login_screen.dart';
import 'package:rentool/screens/registration_screen.dart';

class TermsOfAgreementScreen extends StatefulWidget {
  const TermsOfAgreementScreen({Key? key}) : super(key: key);

  @override
  State<TermsOfAgreementScreen> createState() => _TermsOfAgreementScreenState();
}

class _TermsOfAgreementScreenState extends State<TermsOfAgreementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms of Agreement"),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Container(
          padding:
              const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
          alignment: Alignment.topCenter,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Terms of Agreement",
                    style: GoogleFonts.roboto(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(
                  height: 30,
                ),
                const SafeArea(
                  child: Text(
                      "Business Confidentiality AgreementThis agreement between [Company name] and [Contact name] is hereby entered into on this date: [Date here].\n\nPurpose: [Company name] and [Contact name] will be entering into discussions involving [Company name]'s development and operation, which require [Company name] to disclose confidential information to [Contact name] on an ongoing basis. This agreement’s purpose is to ensure confidentiality and to prevent [Contact name] from disclosing such confidential information.\n\n[Company name] and [Contact name] hereby agree to the following:\n\nA: Throughout this agreement, the term “confidential information” will refer to any information related to [Company name] that is generally not known to any third parties, and is owned by [Company name]. Confidential information includes, but is not limited to: \n\n1. Product strategies \n2. Finances \n3. Contract discussions\n4. Trade secrets\n5. Investing strategies \n6. Marketing strategies \n7. Business plans \n8. Other business affairs of [Company name] \n\nB: [Contact name] understands that any intentional or unintentional disclosure of confidential information may be detrimental to [Company name] and accordingly agrees: \n\n1. Not to disclose discussions with [Company name] except when required by law \n2. Not to use any confidential information in any way other than for authorized purposes \n3. To maintain confidentiality at all times unless expressly written permission is received from [Company name] \n4. That upon dissolution, all records related to [Company name] will be returned \n\nC: The terms outlined above shall not apply when specific information: \n\n1. Becomes part of public domain \n2. Can be proven to be already owned by [Company name] before signing the agreement \n3. [Company name] expressly gives written permission of disclosure \n4. Is court-ordered for disclosure \n\nD: Should a court order for disclosure of confidential information be received by [Contact name], [Company name] must be notified immediately in order to either seek protective orders or waive this agreement according to the circumstances involved. \n\nE: Both parties understand that confidential information is owned by [Company name] and any disclosure of such to [Contact name] does not convey any manner of license, title or right to this information and may not appropriate any portion of it for unauthorized uses. \n\nF: Termination of the relationship between [Company name] and [Contact name] does not relieve [Contact name] and associates of their obligations outlined in this agreement, including the return of all records. \n\nG: This agreement shall be governed under the jurisdiction of the state of [State name]"),
                ),
                const SizedBox(
                  height: 15,
                ),
                SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                    ((route) => false));
                              },
                              child: Text("Decline"))),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (_) => RegistrationScreen(
                                //               checkBox: true,
                                //             )));
                                Navigator.of(context).pop(true);
                              },
                              child: const Text("Accept"))),
                    ],
                  ),
                )
              ]),
        )),
      ),
    );
  }
}

class TermsButton extends StatelessWidget {
  TermsButton(
      {Key? key,
      required this.title,
      required this.onTap,
      this.isAccepted = false})
      : super(key: key);
  final String title;
  final VoidCallback onTap;
  final bool isAccepted;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: size.height * 0.013),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
              border: Border.all(
                  color: isAccepted ? Colors.black : Colors.white,
                  width: size.width * 0.005),
              borderRadius: BorderRadius.circular(size.height * 0.01),
              color: isAccepted ? Colors.black : Colors.white),
          child: Text("$title",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: size.height * 0.023,
                fontWeight: FontWeight.w600,
                color: isAccepted ? Colors.white : Colors.black,
              ))),
    );
  }
}
