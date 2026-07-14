import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samaadhaan/screens/home_screen.dart';
import 'package:samaadhaan/screens/verification_screen.dart';

class PhoneNumberRegistration extends StatefulWidget {
  const PhoneNumberRegistration({Key? key}) : super(key: key);

  static const routeName = "/get-deatils-screen";
  static String verify = "";

  @override
  State<PhoneNumberRegistration> createState() =>
      _PhoneNumberRegistrationState();
}

class _PhoneNumberRegistrationState extends State<PhoneNumberRegistration> {
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late String phoneNumber;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orangeAccent, Colors.white, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: EdgeInsets.only(left: 25, right: 25),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Register With Your Phone Number",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: TextEditingController(text: "+91"),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Text(
                        "|",
                        style: TextStyle(fontSize: 33, color: Colors.grey),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone",
                        ),
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade400,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      if (phoneNumberController.text.length != 10) {
                        const snackBar = SnackBar(
                          elevation: 5,
                          backgroundColor: Color.fromARGB(255, 212, 92, 84),
                          content: Text('Please Enter Correct Phone Number!!'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      // bool phoneNumberExists =
                      //     await _checkIfPhoneNumberExists(
                      //         phoneNumberController.text);
                      // if (phoneNumberExists) {
                      //   Navigator.pushAndRemoveUntil(
                      //       context,
                      //       MaterialPageRoute(builder: (_) => HomeScreen()),
                      //       (route) => false);
                      // } else {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: '+91${phoneNumberController.text}',
                        verificationCompleted:
                            (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          PhoneNumberRegistration.verify = verificationId;
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VerificationScreen(
                            phoneNumber: phoneNumberController.text,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
