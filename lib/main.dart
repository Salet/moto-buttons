import 'package:flutter/material.dart';
import 'package:pubnub/pubnub.dart';
import 'buttons.dart';
import 'stats.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String channel;
  String uuid;
  int currentTabIndex = 0;

  static final channelField = TextEditingController();
  static final uuidField = TextEditingController();

  static final pubnub = PubNub(
      defaultKeyset:
          Keyset(subscribeKey: 'demo', publishKey: 'demo', uuid: UUID('demo')));

  static final buttons = [
    {
      'text': 'Fuel / food / toilet break needed',
      'id': 0,
      'color': Colors.cyan
    },
    {
      'text': 'Quick emergency stop ASAP',
      'id': 1,
      'color': Colors.lightBlue.shade600
    },
    {'text': 'Free to overtake, go go go', 'id': 2, 'color': Colors.green},
    {'text': 'Love those corners!', 'id': 3, 'color': Colors.lightGreen},
    {'text': 'Are we lost?', 'id': 4, 'color': Colors.lime},
    {'text': 'Lagging behind, please wait up', 'id': 5, 'color': Colors.amber},
    {'text': 'OMG! That was close', 'id': 6, 'color': Colors.orange.shade800},
    {
      'text': 'Warning! Obstacles / speed traps ahead',
      'id': 7,
      'color': Colors.red.shade800
    },
  ];

  static final tabs = [
    ButtonsPage(pubnub: pubnub, buttons: buttons),
    StatsPage(),
  ];

  changeTab(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  isFormVisible() {
    return channel == null || uuid == null;
  }

  logIn() {
    setState(() {
      if (channelField.text.isNotEmpty && uuidField.text.isNotEmpty) {
        channel = channelField.text;
        uuid = uuidField.text;
      }
    });
  }

  Widget form() {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Channel', style: TextStyle(fontSize: 18)),
            TextField(controller: channelField),
            SizedBox(height: 20),
            Text('Nickname', style: TextStyle(fontSize: 18)),
            TextField(controller: uuidField),
            SizedBox(height: 20),
            Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: logIn,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15)),
                    child:
                        Text('Start Riding', style: TextStyle(fontSize: 18)))),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: isFormVisible() ? form() : tabs[currentTabIndex]),
      bottomNavigationBar: isFormVisible()
          ? null
          : BottomNavigationBar(
              currentIndex: currentTabIndex,
              onTap: changeTab,
              items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.medical_services_rounded),
                      label: "Buttons"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.insert_chart), label: "Stats"),
                ]),
    );
  }

  @override
  void dispose() {
    channelField.dispose();
    uuidField.dispose();
    super.dispose();
  }
}
