import 'package:flutter/material.dart';

// class SearchScreen extends StatefulWidget {
//   SearchScreen({super.key});

//   Map<String, String> searchMap = {};

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

final ministriesMap = {
  "ministry of planning": "1",
  "ministry of agriculture india": "2",
  "ministry of ayush": "3",
  "ministry of chemicals and fertilizers": "4",
  "ministry of civil aviation india": "5",
  "ministry of co-operation": "6",
  "ministry of coal india": "7",
  "ministry of commerce and industry": "8",
  "ministry of communications india": "9",
  "ministry of consumer affairs, food and public distribution": "10",
  "ministry of corporate affairs india": "11",
  "ministry of culture india": "12",
  "ministry of defence india": "13",
  "ministry of development of north eastern region india": "14",
  "ministry of earth sciences": "15",
  "ministry of education india": "16",
  "ministry of electronics and information technology": "17",
  "ministry of environment forest and climate change": "18",
  "ministry of external affairs india": "19",
  "ministry of finance india": "20",
  "ministry of fisheries animal husbandry and dairying": "21",
  "ministry of food processing industries": "22",
  "ministry of health india": "23",
  "mministr of heavy industries india": "24",
  "ministry of home affairs india": "25",
  "ministry of housing and urban affairs": "26",
  "ministry of information and broadcasting": "27",
  "ministry of jal shakti": "28",
  "ministry of labour and employment": "29",
  "ministry of law and justice": "30",
  "ministry of micro small and medium enterprises": "31",
  "ministry of mines india": "32",
  "ministry of minority affairs": "33",
  "ministry of new and renewable energy": "34",
  "ministry of panchayati raj": "35",
  "ministry of parliamentary affairs": "36",
  "ministry of personnel public grievances and pensions": "37",
  "ministry of petroleum india": "38",
  "ministry of ports, shipping and waterways": "39",
  "ministry of power india": "40",
  "ministry of railways india": "41",
  "ministry of road transport and highways": "42",
  "ministry of rural development": "43",
  "ministry of science and technology india": "44",
  "ministry of skill development and entrepreneurship": "45",
  "ministry of social justice and empowerment": "46",
  "ministry of satistics and programme implementation": "47",
  "ministry of steel india": "48",
  "ministry of textiles india": "49",
  "ministry of tourism india": "50",
  "ministry of tribal affairs": "51",
  "ministry of women and child development": "52",
  "ministry of youth affairs and sports": "53",
  "prime minister's office": "54",
};

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  Map<String, String> searchMap = {};

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _value = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.white, Colors.green.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  child: Container(
                    margin: const EdgeInsets.only(top: 30, left: 10, right: 10),
                    child: Form(
                      child: ListView(
                        children: [
                          TextFormField(
                            style: const TextStyle(fontFamily: "Poppins"),
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: "Search...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              label: const Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Icon(Icons.search),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _value = value.toLowerCase();
                                widget.searchMap.clear();
                                ministriesMap.forEach((key, val) {
                                  if (key.toLowerCase().contains(_value)) {
                                    widget.searchMap[key] = val;
                                  }
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 240,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: widget.searchMap.length,
                    itemBuilder: (_, index) {
                      var ministryKey = widget.searchMap.keys.elementAt(index);
                      var ministryValue = widget.searchMap[ministryKey];
                      return Container(
                        child: Image.asset(
                          "assets/ministries_logos/$ministryValue.png", // Assuming ministry codes correspond to your asset file names
                          fit: BoxFit.contain,
                        ),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 2.0,
                              offset: Offset(-1, 1),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
