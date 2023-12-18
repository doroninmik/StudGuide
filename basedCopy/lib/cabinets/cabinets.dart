class Cabinets{

  List<String> majorBuilding = [
  for (int i = 101; i <= 140; i++) i.toString(),
  for (int i = 201; i <= 227; i++) i.toString(),
  '220А', '220Б','220В','220Г',
  for (int i = 301; i <= 339; i++) i.toString(),
  '302А', '302Б','302В','310А','312А','324А',
  for (int i = 401; i <= 435; i++) i.toString(),
  '418А','426А',
  for (int i = 501; i <= 529; i++) i.toString(),
  '502А', '508А','512А','521А','517Б','517А',
  ];

  List<String> lectionBuilding = ['A1', 'A2', 'A3', 'A4', 
                                  'A5', 'A6', 'A7', 'A8'];

  List<String> buildingA = [
  for (int i = 101; i <= 122; i++) 'A $i',
  for (int i = 201; i <= 219; i++) 'A $i',
  for (int i = 301; i <= 317; i++) 'A $i',
];

List<String> buildingG = ['Г 100', 'Г 101', 'Г 103', 'Спортзал'];

List<String> buildingB = [
  for (int i = 101; i <= 113; i++) 'Б $i',
  for (int i = 201; i <= 215; i++) 'Б $i',
  for (int i = 301; i <= 316; i++) 'Б $i',
];

List<String> buildingD = ['Д1', 'Д2', 'Д3', 'Д4', 'Актовый зал'];

List<String> buildingV = [
  for (int i = 101; i <= 119; i++) 'В $i',
  for (int i = 201; i <= 226; i++) 'В $i',
  for (int i = 301; i <= 322; i++) 'В $i',
];


}