import 'package:flutter/material.dart';
import 'package:samaadhaan/screens/get_complaint_screen.dart';
import 'package:samaadhaan/screens/search_screen.dart';

class HomeScreen extends StatelessWidget {
  String phoneNumber;
  HomeScreen({required this.phoneNumber});

  int? ministry;

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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchScreen(),
                ));
          },
          child: const Icon(Icons.search),
        ),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.transparent,
          title: const ListTile(
            title: Text(
              "Namashkar Naagrik!!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Please Select the Ministry Related to your Complaint",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 240,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemCount: 54,
            itemBuilder: (_, index) {
              print(index + 1);
              ministry = index + 1;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => GetComplaintScreen(
                              ministry: ministry,
                              phoneNumber: phoneNumber,
                            )),
                  );
                },
                child: Container(
                  child: Image.asset("assets/ministries_logos/${index + 1}.png",
                      fit: BoxFit.contain),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 2.0,
                          offset: Offset(-1, 1),
                        ),
                      ]),
                ),
              );
            }),
      ),
    );
  }
}
