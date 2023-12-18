//screen_map.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';


import 'map_marker_model.dart';
import 'map_constants.dart';

class MainMap extends StatefulWidget {
final String searchText;


MainMap({Key? key,required this.searchText}) : super(key: key);


  @override
  _MainMapState createState() => _MainMapState();
}


class _MainMapState extends State<MainMap> {
  String searchText = '';
  int selectedIndex = 0;
  var currentLocation = AppConstants.myLocation;
  late FocusNode searchFocusNode;

  MapMarker? selectedMarker; // Хранение выбранного маркера
  List<LatLng>? selectedMarkerShape;

  late final MapController mapController;
  double currentZoom = 17;

  TextEditingController searchController = TextEditingController();

  bool showErrorSnackBar = false;

  void handleSearch(String searchText) {
  setState(() {
    selectedMarker = null;
    selectedMarkerShape = null;


    final cleanedText = searchText.replaceAll(RegExp(r'\s'), '').toLowerCase(); // Приведение текста к нижнему регистру и удаление всех пробелов

    if (cleanedText == 'большойспортзал' || cleanedText == 'большой спортзал') {
      selectedMarker = mapMarkers[0]; // Индекс 0 соответствует "Главный корпус"
      selectedMarkerShape = selectedMarker!.shape;
    } else if (cleanedText == 'малыйспортзал' || cleanedText == 'малый спортзал') {
      selectedMarker = mapMarkers[4]; // Индекс 4 соответствует "Крыло Г"
      selectedMarkerShape = selectedMarker!.shape;
    } else if (cleanedText == 'спортивнаяплощадка' || cleanedText == 'спортплощадка' || cleanedText == 'спортивная площадка' || cleanedText == 'спортплощадка') {
      selectedMarker = mapMarkers[8]; // Индекс 8 соответствует "Спортивная площадка"
      selectedMarkerShape = selectedMarker!.shape;
    } else if (cleanedText == 'стадион') {
      selectedMarker = mapMarkers[7]; // Индекс 7 соответствует "Стадион"
      selectedMarkerShape = selectedMarker!.shape;
    } else if (cleanedText == 'актовыйзал' || cleanedText == 'актовый зал') {
      selectedMarker = mapMarkers[5]; // Индекс 5 соответствует "Крыло Д"
      selectedMarkerShape = selectedMarker!.shape;
    } else if (cleanedText.length == 2 && (cleanedText.startsWith('А') || cleanedText.startsWith('а')) && int.tryParse(cleanedText.substring(1)) != null) {
      // Если введена буква "А" и одна цифра
      selectedMarker = mapMarkers[6]; // Индекс 6 соответствует "Лекционный корпус"
      selectedMarkerShape = selectedMarker!.shape;
    } else if (cleanedText.length == 3 && int.tryParse(cleanedText) != null) {
      // Если введено три цифры
      selectedMarker = mapMarkers[0]; // Индекс 0 соответствует "Главный корпус"
      selectedMarkerShape = selectedMarker!.shape;
    } else if (cleanedText.length == 4 && (cleanedText.startsWith('А') || cleanedText.startsWith('а')) && int.tryParse(cleanedText.substring(1)) != null) {
      // Если введена буква "А" и три цифры
      selectedMarker = mapMarkers[1]; // Индекс 1 соответствует "Крыло А"
      selectedMarkerShape = selectedMarker!.shape;
    } else if (cleanedText.length == 4 && (cleanedText.startsWith('Б') || cleanedText.startsWith('б')) && int.tryParse(cleanedText.substring(1)) != null) {
      // Если введена буква "Б" и три цифры
      selectedMarker = mapMarkers[2]; // Индекс 2 соответствует "Крыло Б"
      selectedMarkerShape = selectedMarker!.shape;
    } else if (cleanedText.length == 4 && (cleanedText.startsWith('В') || cleanedText.startsWith('в')) && int.tryParse(cleanedText.substring(1)) != null) {
      // Если введена буква "В" и три цифры
      selectedMarker = mapMarkers[3]; // Индекс 3 соответствует "Крыло В"
      selectedMarkerShape = selectedMarker!.shape;
    } else if (cleanedText.length == 4 && (cleanedText.startsWith('Г') || cleanedText.startsWith('г')) && int.tryParse(cleanedText.substring(1)) != null) {
      // Если введена буква "Г" и три цифры
      selectedMarker = mapMarkers[4]; // Индекс 4 соответствует "Крыло Г"
      selectedMarkerShape = selectedMarker!.shape;
    } else if (cleanedText.length == 2 && (cleanedText.startsWith('Д') || cleanedText.startsWith('д')) && int.tryParse(cleanedText.substring(1)) != null) {
      // Если введена буква "Д" и одна цифра
      selectedMarker = mapMarkers[5]; // Индекс 5 соответствует "Крыло Д"
      selectedMarkerShape = selectedMarker!.shape;
     } else {
        if (showErrorSnackBar) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final snackBar = SnackBar(
            content: Text('Аудитория не найдена. Пожалуйста, проверьте правильность введенных данных.'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
        showErrorSnackBar = false; // Сброс флага showErrorSnackBar
  }
    return;
    }
    searchController.text = searchText;
  }); 
}


  @override
  void initState() {
    super.initState();
    searchFocusNode = FocusNode();
    mapController = MapController();
    searchFocusNode.addListener(() {
     setState(() {});
    });
    searchController.text = widget.searchText;
    handleSearch(widget.searchText);
  }


  
  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }


 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            minZoom: 1,
            maxZoom: 18,
            zoom: currentZoom,
            center: LatLng(54.763946, 32.031482),
            rotation: 0,
            onTap: (position, point) {
              setState(() {
                selectedMarker = null;
                selectedMarkerShape = null;
                searchController.clear();
                searchFocusNode.unfocus();
              });
            },
          ),
          layers: [
            TileLayerOptions(
              urlTemplate:
                  "ЗАГЛУШКА",
              additionalOptions: {
                'mapStyleId': AppConstants.mapBoxStyleId,
                'accessToken': AppConstants.mapBoxAccessToken,
              },
            ),
            PolylineLayerOptions(
              polylines: [
               Polyline(
                points: [
                LatLng(54.764110, 32.029767),
                LatLng(54.763997, 32.029930),
                LatLng(54.764023, 32.029793),
                LatLng(54.764084, 32.029917),
                LatLng(54.763997, 32.029930),
                ],
                color: Colors.black,
                strokeWidth: 2,
                ), 
                if (selectedMarkerShape != null)
                  Polyline(
                    points: selectedMarkerShape!,
                    color: Colors.red,
                    strokeWidth: 2.0,
                  ),
              ],
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 70,
                  height: 100,
                  point: LatLng(54.764007, 32.029469),
                  builder: (BuildContext context) {
                    return Align(
                      alignment: Alignment.center,
                      child: Transform.rotate(
                        angle: -mapController.rotation * pi / 180,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Главный вход',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                for (int i = 0; i < mapMarkers.length; i++)
                  Marker(
                    width: 70,
                    height: 100,
                    point: mapMarkers[i].location!,
                    builder: (BuildContext context) {
                      final bool isSelected = selectedMarker == mapMarkers[i];
                      final Color markerColor = isSelected ? Colors.red : Colors.blue;
                      return Align(
                        alignment: Alignment.center,
                        child: Transform.rotate(
                          angle: -mapController.rotation * pi / 180,
                          child: GestureDetector(
                            onTap: () {
                              if (selectedMarker != mapMarkers[i]) {
                                setState(() {
                                  selectedMarker = mapMarkers[i];
                                  selectedMarkerShape = mapMarkers[i].shape;
                                  searchController.clear();
                                });
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 40,
                                  color: markerColor,
                                ),
                                Text(
                                  mapMarkers[i].title ?? '',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
           ],
        ),
        if (selectedMarker != null)
          Positioned(
            bottom: 10,
            left: 10,
            right: 80,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      selectedMarker?.title ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      selectedMarker?.description ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
Positioned(
  top: 10,
  left: 10,
  right: 10,
  child: Padding(
    padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: searchFocusNode,
                controller: searchController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  hintText: 'Введите номер аудитории',
                  filled: true,
                  fillColor: searchFocusNode.hasFocus ? Color.fromARGB(139, 238, 238, 238) : null,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(200, 90, 10, 104)), // Желтая рамка текстового поля
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(200, 90, 10, 104)), // Желтая рамка текстового поля при фокусе
                  ),
                ),
                onSubmitted: (value) {
                  final searchText = searchController.text;
                  if (searchText.isNotEmpty) {
                    handleSearch(searchText);
                  }
                },
              ),
            ),
            SizedBox(width: 10), // Промежуток между текстовым полем и кнопкой
            ElevatedButton(
              onPressed: () {
                final searchText = searchController.text;
                if (searchText.isNotEmpty) {
                  showErrorSnackBar = true; // Установка флага showErrorSnackBar в true при неверном вводе
                  handleSearch(searchText);
                }
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(200, 90, 10, 104), // Желтый цвет кнопки
                onPrimary: Colors.white, // Цвет текста на кнопке
              ),
              child: Text('Найти'),
            ),
          ],
        ),
      ],
    ),
  ),
),
        Positioned(
          bottom: 16,
          right: 16,
          child: Column(
            children: [
              FloatingActionButton(
                backgroundColor: const Color.fromARGB(200, 90, 10, 104),
                heroTag: 'tagHero 1',                
                onPressed: () {
                  mapController.move(mapController.center, (currentZoom + 1).toDouble()); 
                  setState(() {
                    currentZoom++;
                  });
                },
                child: Icon(Icons.add),
              ),
              SizedBox(height: 10),
              FloatingActionButton(
                backgroundColor: const Color.fromARGB(200, 90, 10, 104),
                heroTag: 'tagHero 2',
                onPressed: () {
                  setState(() {
                     mapController.move(mapController.center, (currentZoom - 1).toDouble());
                    currentZoom--;
                  });
                },
                child: Icon(Icons.remove),
              ),
            ],
          ),
        ),   
      ],
    ),
  );
}

}