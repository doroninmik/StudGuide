
import 'package:based/screens/screen_map/screen_map.dart';
import 'package:based/screens/screen_notes/screen_notes.dart';
import 'package:based/screens/screen_timetable/screen_timetable.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

 class MyApp extends StatefulWidget {
  final int selectedTab;

  MyApp({Key? key, this.selectedTab = 0}) : super(key: key);

  @override
  MyAppState createState() => MyAppState(matchText: "");
}


class MyAppState extends State<MyApp> {
  int selectedTab = 0;
  String matchText;

  MyAppState({required this.matchText});

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _widgetOptions = <Widget>[
    ShowTimetable(),
    MainMap(searchText: ''),
    ScreenNotes(),
    Text(
      'Настройки',
      style: optionStyle,
    ),
  ];

  void onSelectedTab(int index) {
    if (selectedTab == index) {
      return;
    }
    setState(() {
      selectedTab = index;
    });
  }

  void buildMapScreen() {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    String searchText = arguments != null ? arguments as String : '';

    setState(() {
      matchText = searchText;
      _widgetOptions[1] = MainMap(searchText: matchText);
      selectedTab = 1;
    });
  }

  String sectionHeader(int _selectedTab) {
    switch (_selectedTab) {
      case 0:
        return 'Расписание';
      case 1:
        return 'Карта';
      case 2:
        return 'Заметки';
      default:
        return 'Расписание';
    }
  }

  @override
  void initState() {
    super.initState();
    selectedTab = widget.selectedTab;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedTab == 1) {
      buildMapScreen();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(200, 90, 10, 104),
        title: Center(child: Text(sectionHeader(selectedTab))),
      ),
      body: IndexedStack(
        index: selectedTab,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 25,
        selectedFontSize: 15,
        unselectedFontSize: 13,
        unselectedItemColor: Color.fromARGB(255, 0, 0, 0),
        selectedItemColor: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: const Color.fromARGB(200, 90, 10, 104),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Расписание',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Карта',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: 'Заметки',
          ),
        ],
        currentIndex: selectedTab,
        onTap: onSelectedTab,
      ),
    );
  }
}
