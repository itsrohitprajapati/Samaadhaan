import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:samaadhaan/screens/registered_screen.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:firebase_storage/firebase_storage.dart';

class GetComplaintScreen extends StatefulWidget {
  int? ministry;
  String phoneNumber = "";
  GetComplaintScreen({required this.ministry, required this.phoneNumber});

  @override
  State<GetComplaintScreen> createState() => _GetComplaintScreenState();
}

class _GetComplaintScreenState extends State<GetComplaintScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  TextEditingController _text = TextEditingController();

  void _startListening() async {
    if (!_speech.isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('status: $status');
        },
        onError: (errorNotification) {
          print('Error: $errorNotification');
        },
      );

      if (available) {
        _speech.listen(
          onResult: (result) {
            setState(() {
              _text.text = result.recognizedWords;
            });
          },
        );
      } else {
        print('The user has denied the use of speech recognition.');
      }
    } else {
      _speech.stop();
    }
  }

  List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    List<XFile>? pickedImages = await ImagePicker().pickMultiImage();
    if (pickedImages != null) {
      if (pickedImages.map((xFile) => File(xFile.path)).toList().length > 10) {
        const snackBar = SnackBar(
          elevation: 5,
          backgroundColor: Color.fromARGB(255, 212, 92, 84),
          content: Text('Only upto 10 photos are allowed!'),
        );
        pickedImages.clear();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        setState(() {
          _selectedImages =
              pickedImages.map((xFile) => File(xFile.path)).toList();
        });
      }
    }
  }

  Future<void> _uploadComplaintToFirebase() async {
    try {
      // Generate a unique ID for the complaint document
      String complaintId = DateTime.now().millisecondsSinceEpoch.toString();

      // Upload images to Firebase Storage
      List<String> imageUrls = [];
      for (File image in _selectedImages) {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('complaints/$complaintId/${image.path.split('/').last}');
        UploadTask uploadTask = storageReference.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      // Create a map with user information
      Map<String, dynamic> complaintData = {
        'phoneNumber': widget.phoneNumber,
        'ministry': widget.ministry,
        'complaintText': _text,
        'imageUrls': imageUrls,
        // Add other user information here if needed
      };

      // Upload user's complaint data to Firestore
      await FirebaseFirestore.instance
          .collection('complaints')
          .doc(complaintId) // Use the unique ID as the document ID
          .set(complaintData);

      // Navigate to the next screen after successful upload
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RegisteredScreen(),
        ),
      );
    } catch (error) {
      // Handle errors during upload
      print('Error uploading complaint: $error');
      // Display an error message to the user if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.white, Colors.green.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Please tell us about your Problem below",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.mic),
                        onPressed: _startListening,
                      ),
                      Expanded(
                        child: TextField(
                          maxLines: 15,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Write your complaint here...",
                            contentPadding: const EdgeInsets.all(10),
                          ),
                          controller: _text,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    height: 55,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt),
                        SizedBox(width: 10),
                        Text(
                          "Add Photos (Up to 10)",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                // Display selected images
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Image.file(_selectedImages[index]);
                  },
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 50, top: 20),
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade400,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      if (_text.text.length < 100) {
                        const snackBar = SnackBar(
                          elevation: 5,
                          backgroundColor: Color.fromARGB(255, 212, 92, 84),
                          content: Text(
                              'Complaint should Consist of atleast 100 Characters!'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RegisteredScreen(),
                          ),
                        );
                      }
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
