// import 'package:flutter/material.dart';

// class RegisterScreen extends StatelessWidget {
//   const RegisterScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white70,
//       body: Center(child: Column(children: [
//         Row(children: [
//           Text("Regiester Here");
//         ],)
//       ],),),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:samaadhaan/screens/get_details_screen.dart';
import 'package:samaadhaan/screens/home_screen.dart';
import 'package:samaadhaan/screens/phone_number_registration.dart';

class VerificationScreen extends StatefulWidget {
  String phoneNumber;
  VerificationScreen({required this.phoneNumber});

  static const routeName = "/verification-screen";

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // void addChatUserDialog() {
  //   String phoneNumber = '';

  //   showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //             contentPadding: const EdgeInsets.only(
  //                 left: 24, right: 24, top: 20, bottom: 10),

  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20)),

  //             //title
  //             title: Row(
  //               children: const [
  //                 Icon(
  //                   Icons.person_add,
  //                   color: Colors.orangeAccent,
  //                   size: 28,
  //                 ),
  //                 Text(
  //                   '  Save',
  //                 )
  //               ],
  //             ),

  //             //content
  //             content: TextFormField(
  //               maxLines: null,
  //               onChanged: (value) => phoneNumber = value,
  //               decoration: InputDecoration(
  //                   prefixIcon:
  //                       const Icon(Icons.call, color: Colors.orangeAccent),
  //                   border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(15))),
  //             ),

  //             //actions
  //             actions: [
  //               //cancel button
  //               MaterialButton(
  //                 onPressed: () {
  //                   //hide alert dialog
  //                   Navigator.pop(context);
  //                 },
  //                 child: const Text(
  //                   'Cancel',
  //                   style: TextStyle(
  //                     color: Colors.orangeAccent,
  //                     fontSize: 16,
  //                   ),
  //                 ),
  //               ),

  //               //add button
  //               MaterialButton(
  //                 onPressed: () {},
  //                 child: const Text(
  //                   'Add',
  //                   style: TextStyle(
  //                       color: Colors.orangeAccent,
  //                       fontSize: 16,
  //                       fontFamily: "Poppins"),
  //                 ),
  //               ),
  //             ],
  //           ));
  // }

  Future<bool> _checkIfPhoneNumberExists(String phoneNumber) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users') // Change 'users' to the actual collection name
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    final List<DocumentSnapshot> documents = result.docs;
    return documents.isNotEmpty; // Returns true if the phone number exists
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  var code = "";
  bool _verifying = false;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade400),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
          ),
          elevation: 0,
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.only(left: 25, right: 25),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Phone Verification",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "We need to register your phone before getting started!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Pinput(
                    onChanged: (value) => code = value,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    showCursor: true,
                    onCompleted: (pin) => print(pin),
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
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          try {
                            setState(() {
                              _verifying = true;
                            });
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId:
                                        PhoneNumberRegistration.verify,
                                    smsCode: code);
                            await auth.signInWithCredential(credential);
                            // bool phoneNumberExists =
                            //     await _checkIfPhoneNumberExists(
                            //         widget.phoneNumber);
                            // if (phoneNumberExists) {
                            //   Navigator.pushAndRemoveUntil(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (_) => HomeScreen(
                            //                 phoneNumber: widget.phoneNumber,
                            //               )),
                            //       (route) => false);
                            // } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GetDetailsScreen(
                                    phoneNumber: widget.phoneNumber,
                                  ),
                                ));
                            // }
                          } catch (e) {
                            setState(() {
                              _verifying = false;
                            });
                            const snackBar = SnackBar(
                              elevation: 5,
                              backgroundColor: Color.fromARGB(255, 212, 92, 84),
                              content: Text('Please Enter Correct OTP!!'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child: _verifying
                            ? Container(
                                child:
                                    const CircularProgressIndicator.adaptive(),
                              )
                            : const Text("Verify")),
                  ),
                  // Row(
                  //   children: [
                  //     TextButton(
                  //       onPressed: () => addChatUserDialog(),
                  //       child: Text(
                  //         "Edit Phone Number?",
                  //         style: TextStyle(color: Colors.black),
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
