import 'package:based/main.dart';


import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


class ShowTimetable extends StatefulWidget {

  ShowTimetable({super.key});
  @override
  _ShowTimetableState createState() => _ShowTimetableState();
  
}

class _ShowTimetableState extends State<ShowTimetable> {
  TextEditingController _groupNumberController = TextEditingController();
  String _lastSearchedGroupNumber = ''; // Последний введенный номер группы
  List<dynamic> _schedule = [];
  bool _isLoading = false;
  bool _showColumnHeaders = false;
  String? searchText;
  String? selectedSubject; // Добавить поле для хранения выбранного предмета
 


  List<String> groupNames = [
  'Э - 21', 'ЭС - 21', 'ЭСу - 21', 'ЭМ - 21', 'ЭП - 21', 'РТ  - 21', 'ЭО - 21',
  'ПЭ1 - 21', 'ПЭ2 - 21', 'ОЭС - 21', 'ОЭП - 21', 'ПГЭС - 21', 'ТМ1 - 21', 'ТМ2 - 21',
  'Э - 22', 'ЭС - 22', 'ЭМ - 22', 'ЭП - 22', 'РТ - 22', 'ЭО - 22', 'ТМ - 22',
  'ИВТ1 - 21', 'ИВТ2 - 21', 'ИВТ3 - 21', 'ПИЭ - 21', 'ИТЭК - 21', 'БЭИС - 21', 'ЭКО - 21', 'ЭКОо-з - 21',
  'ПЭ - 22', 'ОЭС - 22', 'ОЭП - 22', 'ПГЭС - 22', 'ПГЭСо-з - 22', 'ПГЭСо-зу - 22', 'ЭКО - 22', 'ЭКО о-з - 22',
  'ИВТ1 - 22', 'ИВТ2 - 22', 'ИВТ3 - 22', 'ИВТ4 - 22', 'ПИ1 - 22', 'ПИ2 - 22', 'ПИ3- 22',
  'Э1 - 19', 'Э2 - 19', 'ЭС - 19', 'ЭМ - 19', 'ЭП - 19', 'РТ - 19', 'ЭО - 19',
  'ПО1 - 19', 'ПО2 - 19', 'ПИЭ - 19', 'ИТЭК - 19', 'БЭИС - 19', 'ТМ1 - 19', 'ТМ2 - 19',
  'АС1 - 20', 'АС2 - 20', 'ПО - 20', 'ПИЭ - 20', 'ИТЭК - 20', 'БЭИС - 20',
  'Э - 20', 'ЭС - 20', 'ЭМ - 20', 'ЭП - 20', 'РТ - 20', 'ЭО - 20',
  'ПЭ1 - 20', 'ПЭ2 - 20', 'ПЭ3 - 20', 'ОЭС - 20', 'ОЭП - 20', 'ТМ1 - 20', 'ТМ2 - 20',
  'ПЭ1 - 19', 'ПЭ2 - 19', 'ПЭ3 - 19', 'ОЭС - 19', 'ОЭП - 19'
  ];

  Future<void> fetchSchedule(String groupNumber) async {
  setState(() {
    _isLoading = true;
  });

  try {
    // Проверяем, совпадает ли введенный номер группы с последним введенным
  if (groupNumber == _lastSearchedGroupNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: const Text('Расписание данной группы уже на экране.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ну да, чего это я'),
            ),
          ],
        );
      },
    );
  } else {
    final response = await Dio().get(
      'Заглушка для ссылки на Google sheets с таблицами расписания',
    );

    final data = response.data;
    _schedule = List<dynamic>.from(data);
    _lastSearchedGroupNumber = groupNumber;
    _showColumnHeaders = true;
    checkAndReplaceEmptyLessons();
    removeEmptyLessonRows();
    removeDuplicateDayNames();
  }
  } catch (error) {
    print('Error: $error');
  }

  setState(() {
    _isLoading = false;
  });
}


  void checkAndReplaceEmptyLessons() {
    final daysWithNoLessons = <String>{};
    final daysWithOtherSubjects = <String>{};

    for (final item in _schedule) {
      final day = item[0].toString();
      final subject = item[2].toString();

      if (subject != 'Пар нет') {
        daysWithOtherSubjects.add(day);
        daysWithNoLessons.remove(day);
      } else if (!daysWithOtherSubjects.contains(day)) {
        daysWithNoLessons.add(day);
      }
    }

    for (final day in daysWithNoLessons) {
      bool isFirstRow = true;

      for (int i = 0; i < _schedule.length; i++) {
        final item = _schedule[i];

        if (item[0].toString() == day) {
          if (isFirstRow) {
            item[1] = 'Весь день';
            item[2] = 'Нет занятий';
            isFirstRow = false;
          } else {
            _schedule.removeAt(i);
            i--;
          }
        }
      }
    }
  }

  void removeEmptyLessonRows() {
    _schedule.removeWhere((item) {
      final subject = item[2].toString();
      return subject == 'Пар нет';
    });
  }

  void removeDuplicateDayNames() {
    String previousDay = '';
    for (final item in _schedule) {
      final day = item[0].toString();
      if (day == previousDay) {
        item[0] = '';
      } else {
        previousDay = day;
      }
    }
  } 
  

 Widget parseSubjectText(BuildContext context, String subjectText) {
  final pattern = RegExp(r'(([А-Д]\s+\d+)|(\d{3}(?!\s*[А-Д])))');
  final matches = pattern.allMatches(subjectText);

  if (matches.isEmpty) {
    return Text(
      subjectText,
      style: TextStyle(color: Colors.black), // Цвет текста по умолчанию
    );
  }

  final spans = <InlineSpan>[];
  var previousIndex = 0;

  for (final match in matches) {
    final matchText = match.group(0);
    final startIndex = match.start;
    final endIndex = match.end;

    if (previousIndex != startIndex) {
      final nonMatchText = subjectText.substring(previousIndex, startIndex);
      spans.add(TextSpan(
        text: nonMatchText,
        style: TextStyle(color: Colors.black), // Цвет текста по умолчанию
      ));
    }

    if (startIndex == endIndex) {
      spans.add(TextSpan(text: matchText));
    } else {
      final hyperlinkText = GestureDetector(
        child: Text(
          matchText!,
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
        onTap: () async {
          // Открыть экран карты и передать текст в экран MainMap
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyApp(
                selectedTab: 1,
              ),
              settings: RouteSettings(arguments: matchText),
            ),
          );
        },
      );
      spans.add(WidgetSpan(child: hyperlinkText));
    }

    previousIndex = endIndex;
  }

  if (previousIndex != subjectText.length) {
    final remainingText = subjectText.substring(previousIndex);
    spans.add(TextSpan(
      text: remainingText,
      style: TextStyle(color: Colors.black), // Цвет текста по умолчанию
    ));
  }

  return RichText(text: TextSpan(children: spans));
}


  @override
  void dispose() {
    _groupNumberController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TypeAheadField<String>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _groupNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Номер группы',
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    return groupNames.where((group) => group.toLowerCase().contains(pattern.toLowerCase()));
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    _groupNumberController.text = suggestion;
                    fetchSchedule(suggestion).then((_) {});
                  },
                  noItemsFoundBuilder: (context) {
                    return ListTile(
                      title: Text('Нет групп с таким номером'),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          if (_showColumnHeaders)
            Container(
              child: Table(
                border: TableBorder(
                  verticalInside: BorderSide(color: Colors.black, width: 2),
                  bottom: BorderSide(color: Colors.black, width: 2),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(3),
                },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              'День',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Время',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Предмет',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Container(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                    itemCount: _schedule.length,
                    itemBuilder: (context, index) {
                      final item = _schedule[index];
                      final subject = item[2].toString();
                      final hasEvenWeek = subject.contains('(нечет.)');
                      final hasOddWeek = subject.contains('(чет.)');

                      String subjectText = subject;
                      if (hasEvenWeek && hasOddWeek) {
                          subjectText = subjectText.replaceFirst('(нечет.)', '(нечет.)\n');
                        } 

                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black),
                            ),
                          ),
                          child: Table(
                            border: TableBorder(
                              horizontalInside: BorderSide(color: Colors.black,),
                              verticalInside: BorderSide(color: Colors.black, width: 2), 
                            ),
                            columnWidths: const {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(3),
                            },
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        item[0].toString().isNotEmpty
                                            ? item[0]
                                                .toString()
                                                .replaceFirst(item[0].toString()[0], item[0].toString()[0].toUpperCase())
                                            : '', 
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        item[1].toString(),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                  child: Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: parseSubjectText(context, subjectText),
                                      );
                                    },
                                  ),
                                ),

                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              ),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}

