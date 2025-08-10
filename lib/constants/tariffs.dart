import 'package:flutter_try_thesis/constants/tariffsClassBlueprint.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const String terminal1Zone1 = 'Crossing Mendez Terminal';
const String terminal1Zone1A = 'KSTODA Mahogany Terminal';
const String terminal1Zone1B = 'Radar Taas Terminal';
const String terminal2Zone1B = 'Terminal Baba';
const String terminal1Zone1C = 'Patuto Terminal';
// const String terminal2Zone1C = 'Patuto South Terminal';
// const String terminal3Zone1C = 'Guinhawa Terminal';
// const String terminal4Zone1C = 'Zambal Terminal';
// const String terminal5Zone1C = 'Asisan Terminal';
const String terminal1Zone1D = 'Kanto Mater Dei Terminal';
const String dummyTerminalZone1A = 'CCT DUMMY TERMINAL';
const String terminal1Zone2 = 'Kanto NBI Terminal';
const String terminal1Zone2A = 'Magallanes Terminal';
const String terminal2Zone2A = 'Tagaste Terminal';
const String terminal1Zone3 = 'Ayala Terminal';
const String terminal2Zone3 = 'Olivarez Terminal';
const String terminal3Zone3 = 'Fora Terminal';
const String terminal4Zone3 = 'Grand Terminal';
const String terminal5Zone3 = 'Dominican Terminal';
const String terminal6Zone3 = 'Tolentino Terminal';
const String terminal7Zone3 = 'Wet Market Terminal';
const String terminal8Zone3 = 'City Market Terminal';
const String terminal1Zone3A = 'People\'s Park Terminal';
const String terminal2Zone3A = 'St. Michael Terminal';
const String terminal3Zone3A = 'Picnic Grove Terminal';
const String terminal4Zone3A = 'TagSci Terminal';
const String terminal5Zone3A = 'Mariapolis Terminal';
const String terminal6Zone3A = 'Near TagSci Terminal';
const String terminal7Zone3A = 'Ligaya Drive Terminal';
const String terminal1Zone4 = 'Ayala Terminal';
const String terminal2Zone4 = 'Olivarez Plaza Terminal';
const String terminal3Zone4 = 'Kanto SVD Terminal';
const String terminal1Zone4A = 'Kanto TCI Terminal';

const List<Map<String, dynamic>> zone1AMahoganyTerminalFare = [
  {
    "Name": "Crossing Mendez",
    "LatLng": LatLng(14.0974251, 120.9184181),
    "Price": 40
  },
  {
    "Name": "Crossing Ilalim",
    "LatLng": LatLng(14.0993497, 120.9195836),
    "Price": 50
  },
  {"Name": "Kampo", "LatLng": LatLng(14.1088300, 120.9359999), "Price": 50},
  {
    "Name": "Motorpool / Purok 80",
    "LatLng": LatLng(14.1032844, 120.9379151),
    "Price": 40
  },
  {
    "Name": "Kaybagal Central",
    "LatLng": LatLng(14.1122220, 120.9399815),
    "Price": 50
  },
  {
    "Name": "Kaybagal - Kalye Pogi",
    "LatLng": LatLng(14.1184282, 120.9366197),
    "Price": 60
  },
  {
    "Name": "Kaybagal North",
    "LatLng": LatLng(14.1200293, 120.9364317),
    "Price": 60
  },
  {
    "Name": "Kaybagal Looban",
    "LatLng": LatLng(14.1200694, 120.9345641),
    "Price": 80
  },
  {
    "Name": "Patutong Malaki",
    "LatLng": LatLng(14.1154527, 120.9216522),
    "Price": 70
  },
  {
    "Name": "Pueblo Del Sol",
    "LatLng": LatLng(14.1149233, 120.9258660),
    "Price": 70
  },
  {
    "Name": "Las Brisas",
    "LatLng": LatLng(14.1004884, 120.9157573),
    "Price": 70
  },
];
// List<TariffsClass> zone1AMahoganyFare = zone1AMahoganyTerminalFare.map((map) {
//   return TariffsClass(
//       placeName: map['Name'],
//       locationLatLng: map['LatLng'],
//       price: map['Price']);
// }).toList();

const List<Map<String, dynamic>> zone1BRadarTaasTerminalFare = [
  {
    "Name": "Osorio Street",
    "LatLng": LatLng(14.0908108, 120.9093828),
    "Price": 40,
  },
  {
    "Name": "Puzzle Mansion",
    "LatLng": LatLng(14.0973735, 120.9025435),
    "Price": 40,
  },
  {
    "Name": "La Bella",
    "LatLng": LatLng(14.0921755, 120.9036435),
    "Price": 40,
  },
  {
    "Name": "Cuadra Street",
    "LatLng": LatLng(14.0994413, 120.9014548),
    "Price": 40,
  },
  {
    "Name": "Woods Borough",
    "LatLng": LatLng(14.1016351, 120.9061277),
    "Price": 40,
  },
  {
    "Name": "Neogan Brgy. Hall",
    "LatLng": LatLng(14.0942479, 120.9003474),
    "Price": 40,
  },
  {
    "Name": "God's Family",
    "LatLng": LatLng(14.0956562, 120.9008384),
    "Price": 40,
  },
  {
    "Name": "Le Jardin",
    "LatLng": LatLng(14.0953402, 120.9013291),
    "Price": 40,
  },
  {
    "Name": "Antonio's",
    "LatLng": LatLng(14.1001719, 120.8943548),
    "Price": 40,
  },
  {
    "Name": "Pabahay Neogan",
    "LatLng": LatLng(14.0987727, 120.8966106),
    "Price": 40,
  },
  {
    "Name": "Neogan Elem. School",
    "LatLng": LatLng(14.0983907, 120.8941491),
    "Price": 40,
  },
  {
    "Name": "Neogan Purok 134",
    "LatLng": LatLng(14.09284, 120.9005977),
    "Price": 40,
  },
  {
    "Name": "Neogan Purok 135",
    "LatLng": LatLng(14.0893512, 120.9009203),
    "Price": 40,
  },
  {
    "Name": "Neogan Purok 136",
    "LatLng": LatLng(14.09184478, 120.90188026),
    "Price": 40,
  },
  {
    "Name": "Neogan Purok 137",
    "LatLng": LatLng(14.09278131, 120.90072155),
    "Price": 40,
  },
  {
    "Name": "Neogan Purok 138",
    "LatLng": LatLng(14.09275009, 120.90066791),
    "Price": 40,
  },
  {
    "Name": "Crossing Mendez",
    "LatLng": LatLng(14.0974251, 120.9184181),
    "Price": 40,
  },
  {
    "Name": "Crossing Mendez Elem. School",
    "LatLng": LatLng(14.1006663, 120.9195032),
    "Price": 50,
  },
  {
    "Name": "Guinhawa Integrated School",
    "LatLng": LatLng(14.1061473, 120.9022115),
    "Price": 50,
  },
  {
    "Name": "Zambal Boundary, Old Brgy. Hall",
    "LatLng": LatLng(14.1024471, 120.8960374),
    "Price": 40,
  },
  {
    "Name": "Zambal Purok 211",
    "LatLng": LatLng(14.09723500, 120.89864016),
    "Price": 50,
  },
  {
    "Name": "Zambal Court",
    "LatLng": LatLng(14.1025485, 120.8943892),
    "Price": 50,
  },
  {
    "Name": "Zambal Brgy. Hall",
    "LatLng": LatLng(14.1023613, 120.8961623),
    "Price": 50,
  },
  {
    "Name": "Zambal Purok 212",
    "LatLng": LatLng(14.10740117, 120.89398384),
    "Price": 60,
  },
  {
    "Name": "Zambal Purok 213",
    "LatLng": LatLng(14.09560130, 120.90174079),
    "Price": 80,
  },
  {
    "Name": "Pabahay Zambal",
    "LatLng": LatLng(14.1006231, 120.8898853),
    "Price": 80,
  },
];

const List<Map<String, dynamic>> zone1BTerminalBabaTerminalFare = [
  {
    "Name": "Brgy. Hall Neogan",
    "LatLng": LatLng(14.0942479, 120.9003474),
    "Price": 40,
  },
  {
    "Name": "Le Jardin",
    "LatLng": LatLng(14.0953402, 120.9013291),
    "Price": 40,
  },
  {
    "Name": "Guinhawa Integrated School",
    "LatLng": LatLng(14.1061473, 120.9022115),
    "Price": 50,
  },
  {
    "Name": "Asisan Elem. School",
    "LatLng": LatLng(14.0990455, 120.9085348),
    "Price": 50,
  },
];

const List<Map<String, dynamic>> zone1CPatutoTerminalFare = [
  {
    "Name": "Emerald Loob",
    "LatLng": LatLng(14.1149226, 120.9161100),
    "Price": 40,
  },
  {
    "Name": "Olivar Compound",
    "LatLng": LatLng(14.1112071, 120.9240790),
    "Price": 40,
  },
  {
    "Name": "Sabungan Teo's Loob",
    "LatLng": LatLng(14.1191380, 120.9159136),
    "Price": 40,
  },
  {
    "Name": "Moonlyn Resort",
    "LatLng": LatLng(14.1177021, 120.9170079),
    "Price": 45,
  },
  {
    "Name": "Kanto ni Tan",
    "LatLng": LatLng(14.1147731, 120.9173479),
    "Price": 50,
  },
  {
    "Name": "Patuto Pabahay",
    "LatLng": LatLng(14.1070155, 120.9241834),
    "Price": 50,
  },
  {
    "Name": "Pueblo",
    "LatLng": LatLng(14.1149233, 120.9258660),
    "Price": 60,
  },
  {
    "Name": "Niko (Pulo)",
    "LatLng": LatLng(14.1216306, 120.9172312),
    "Price": 100,
  },
  {
    "Name": "Las Brisas",
    "LatLng": LatLng(14.1004884, 120.9157573),
    "Price": 40,
  },
  {
    "Name": "TCNHS",
    "LatLng": LatLng(14.1024382, 120.9240204),
    "Price": 50,
  },
  {
    "Name": "Las Brisa",
    "LatLng": LatLng(14.1029706, 120.9117644),
    "Price": 50,
  },
  {
    "Name": "Tropical (Loob)",
    "LatLng": LatLng(14.1069747, 120.9129248),
    "Price": 50,
  },
  {
    "Name": "Gabriel Height",
    "LatLng": LatLng(14.1095236, 120.9282532),
    "Price": 60,
  },
  {
    "Name": "Little Souls",
    "LatLng": LatLng(14.1057932, 120.9282267),
    "Price": 60,
  },
  {
    "Name": "Mater Dei",
    "LatLng": LatLng(14.1023752, 120.9286463),
    "Price": 70,
  },
  {
    "Name": "Cuadra",
    "LatLng": LatLng(14.1090045, 120.9030412),
    "Price": 40,
  },
  {
    "Name": "Main Road Guinhawa",
    "LatLng": LatLng(14.1085454, 120.9022431),
    "Price": 40,
  },
  {
    "Name": "Guinhawa Pabahay",
    "LatLng": LatLng(14.1053664, 120.9052625),
    "Price": 40,
  },
  {
    "Name": "Perlado's Compound",
    "LatLng": LatLng(14.1081115, 120.9062549),
    "Price": 40,
  },
  {
    "Name": "Rehab",
    "LatLng": LatLng(14.1065592, 120.9049208),
    "Price": 40,
  },
  {
    "Name": "Guinhawa Simbahan",
    "LatLng": LatLng(14.1061420, 120.9025325),
    "Price": 40,
  },
  {
    "Name": "BJMP",
    "LatLng": LatLng(14.1146213, 120.9026692),
    "Price": 50,
  },
  {
    "Name": "Main Road Zambal",
    "LatLng": LatLng(14.0967194, 120.8999505),
    "Price": 50,
  },
  {
    "Name": "Ul-ong",
    "LatLng": LatLng(14.1070688, 120.8985780),
    "Price": 50,
  },
  {
    "Name": "Zambal Brgy. Hall",
    "LatLng": LatLng(14.1023613, 120.8961623),
    "Price": 70,
  },
  {
    "Name": "Zambal Court",
    "LatLng": LatLng(14.1025485, 120.8943892),
    "Price": 70,
  },
  {
    "Name": "Crossing Mendez",
    "LatLng": LatLng(14.0974251, 120.9184181),
    "Price": 50,
  },
  {
    "Name": "Asisan Simbahan",
    "LatLng": LatLng(14.0977849, 120.9087316),
    "Price": 50,
  },
  {
    "Name": "Loob, Soto Grande",
    "LatLng": LatLng(14.0929635, 120.9129113),
    "Price": 60,
  },
  {
    "Name": "Puzzle Mansion",
    "LatLng": LatLng(14.0973735, 120.9025435),
    "Price": 70,
  },
  {
    "Name": "Mahogany",
    "LatLng": LatLng(14.1040108, 120.9313761),
    "Price": 80,
  },
  {
    "Name": "NBI",
    "LatLng": LatLng(14.1028110, 120.9412760),
    "Price": 100,
  },
  {
    "Name": "Neogan",
    "LatLng": LatLng(14.0950930, 120.8997650),
    "Price": 100,
  },
  {
    "Name": "Pabahay Zambal",
    "LatLng": LatLng(14.1006231, 120.8898853),
    "Price": 120,
  },
];

const List<Map<String, dynamic>> zone1DKantoMaterDeiTerminalFare = [
  {
    "Name": "Little Souls",
    "LatLng": LatLng(14.1057932, 120.9282267),
    "Price": 40,
  },
  {
    "Name": "Munting Hardin",
    "LatLng": LatLng(14.1059102, 120.9273040),
    "Price": 40,
  },
  {
    "Name": "Maligaya Compound",
    "LatLng": LatLng(14.1092736, 120.9269684),
    "Price": 40,
  },
  {
    "Name": "Gabriel Heights",
    "LatLng": LatLng(14.1095236, 120.9282532),
    "Price": 40,
  },
  {
    "Name": "Moderna Gate",
    "LatLng": LatLng(14.1152458, 120.9256133),
    "Price": 40,
  },
  {
    "Name": "Pabahay Patuto",
    "LatLng": LatLng(14.1070150, 120.9241791),
    "Price": 40,
  },
  {
    "Name": "Kanluran (Magsino's)",
    "LatLng": LatLng(14.1097178, 120.9200693),
    "Price": 40,
  },
  {
    "Name": "Gabriel Heights Loob",
    "LatLng": LatLng(14.1087803, 120.9297306),
    "Price": 45,
  },
  {
    "Name": "Pueblo Loob",
    "LatLng": LatLng(14.1154054, 120.9289135),
    "Price": 45,
  },
  {
    "Name": "Moderna Loob",
    "LatLng": LatLng(14.1150617, 120.9237894),
    "Price": 45,
  },
  {
    "Name": "Pungol Rd.",
    "LatLng": LatLng(14.1108650, 120.9238150),
    "Price": 50,
  },
  {
    "Name": "Loob Balquiz Farm",
    "LatLng": LatLng(14.1207193, 120.9261109),
    "Price": 50,
  },
  {
    "Name": "Emerald",
    "LatLng": LatLng(14.1149226, 120.9161100),
    "Price": 70,
  },
  {
    "Name": "Trablesa",
    "LatLng": LatLng(14.1126375, 120.9153594),
    "Price": 70,
  },
  {
    "Name": "Kanto Guinhawa",
    "LatLng": LatLng(14.1112521, 120.9106898),
    "Price": 70,
  },
  {
    "Name": "Tagaytay Cockpit Arena",
    "LatLng": LatLng(14.1191380, 120.9159136),
    "Price": 80,
  },
  {
    "Name": "Moonlin Resort",
    "LatLng": LatLng(14.1177021, 120.9170079),
    "Price": 80,
  },
  {
    "Name": "Vergara Farm",
    "LatLng": LatLng(14.1304374, 120.9254052),
    "Price": 80,
  },
  {
    "Name": "Sunlink Farm",
    "LatLng": LatLng(14.1540490, 120.9398790),
    "Price": 150,
  },
  {
    "Name": "Wowas Farm",
    "LatLng": LatLng(14.1240720, 120.9196148),
    "Price": 150,
  },
  {
    "Name": "Bahay ni Titser",
    "LatLng": LatLng(14.1031064, 120.9243270),
    "Price": 40,
  },
  {
    "Name": "Savemore",
    "LatLng": LatLng(14.0974251, 120.9184181),
    "Price": 40,
  },
  {
    "Name": "Mendez Crossing Elem. School",
    "LatLng": LatLng(14.1006647, 120.9194974),
    "Price": 40,
  },
  {
    "Name": "Water District",
    "LatLng": LatLng(14.1059808, 120.9399795),
    "Price": 50,
  },
  {
    "Name": "Rough Road - Kaybagal North",
    "LatLng": LatLng(14.1210595, 120.9354870),
    "Price": 60,
  },
];

const List<Map<String, dynamic>> zone2AMagallanesTerminalFare = [
  {
    "Name": "Primark Labas",
    "LatLng": LatLng(14.1015569, 120.9467779),
    "Price": 40,
  },
  {
    "Name": "EVM",
    "LatLng": LatLng(14.1098942, 120.9492484),
    "Price": 40,
  },
  {
    "Name": "Richmore",
    "LatLng": LatLng(14.1161502, 120.9463926),
    "Price": 40,
  },
  {
    "Name": "Alta Monte",
    "LatLng": LatLng(14.1168957, 120.9443316),
    "Price": 40,
  },
  {
    "Name": "Wingate",
    "LatLng": LatLng(14.1188147, 120.9450015),
    "Price": 40,
  },
  {
    "Name": "The Glenn\'s",
    "LatLng": LatLng(14.1221137, 120.9447098),
    "Price": 40,
  },
  {
    "Name": "Kanto - Diversion Road (Angcaya\'s Comp.)",
    "LatLng": LatLng(14.1266814, 120.9435100),
    "Price": 50,
  },
  {
    "Name": "Nurture Spa",
    "LatLng": LatLng(14.1249519, 120.9418207),
    "Price": 55,
  },
  {
    "Name": "Maitim West Brgy. Hall",
    "LatLng": LatLng(14.1266493, 120.9406109),
    "Price": 55,
  },
  {
    "Name": "Metrogate Manors (Loob)",
    "LatLng": LatLng(14.1242570, 120.9472670),
    "Price": 60,
  },
  {
    "Name": "Tagaytay Cemetery",
    "LatLng": LatLng(14.1292220, 120.9470170),
    "Price": 70,
  },
  {
    "Name": "Tagaytay Memorial",
    "LatLng": LatLng(14.1287430, 120.9476540),
    "Price": 70,
  },
  {
    "Name": "Lourdes Street",
    "LatLng": LatLng(14.1262537, 120.9503836),
    "Price": 80,
  },
  {
    "Name": "SMI (Samuel Mission International School)",
    "LatLng": LatLng(14.1241768, 120.9509668),
    "Price": 80,
  },
  {
    "Name": "TCI Kanto",
    "LatLng": LatLng(14.1314354, 120.9569716),
    "Price": 80,
  },
  {
    "Name": "SVD",
    "LatLng": LatLng(14.1290422, 120.9638935),
    "Price": 120,
  },
  {
    "Name": "Maharlika East",
    "LatLng": LatLng(14.1032150, 120.9484660),
    "Price": 40,
  },
  {
    "Name": "Maharlika West",
    "LatLng": LatLng(14.1041816, 120.9470975),
    "Price": 40,
  },
  {
    "Name": "HighGrove",
    "LatLng": LatLng(14.1042974, 120.9461903),
    "Price": 40,
  },
  {
    "Name": "Sta. Rita",
    "LatLng": LatLng(14.1129946, 120.9428705),
    "Price": 40,
  },
  {
    "Name": "Water District",
    "LatLng": LatLng(14.1059028, 120.9407559),
    "Price": 40,
  },
  {
    "Name": "Carlos Batino Elementary School",
    "LatLng": LatLng(14.1133220, 120.9379983),
    "Price": 50,
  },
  {
    "Name": "Metrogate",
    "LatLng": LatLng(14.1147022, 120.9374654),
    "Price": 50,
  },
  {
    "Name": "Pabahay",
    "LatLng": LatLng(14.1152498, 120.9362197),
    "Price": 60,
  },
  {
    "Name": "Kalye Pogi Loob",
    "LatLng": LatLng(14.1185495, 120.9372820),
    "Price": 60,
  },
  {
    "Name": "Tuklong (Kaybagal North)",
    "LatLng": LatLng(14.1236191, 120.9345055),
    "Price": 70,
  },
  {
    "Name": "Bayot Street",
    "LatLng": LatLng(14.1199622, 120.9362722),
    "Price": 60,
  },
  {
    "Name": "Iglesia Kanto",
    "LatLng": LatLng(14.1215170, 120.9358220),
    "Price": 60,
  },
  {
    "Name": "Kimberly Hotel",
    "LatLng": LatLng(14.1221266, 120.9343643),
    "Price": 60,
  }
];

// List<TariffsClass> zone2AMagallanesFare =
//     zone2AMagallanesTerminalFare.map((map) {
//   return TariffsClass(
//       placeName: map['Name'],
//       locationLatLng: map['LatLng'],
//       price: map['Price']);
// }).toList();

const List<Map<String, dynamic>> zone2ATagasteTerminalFare = [
  {
    "Name": "Magallanes Square",
    "LatLng": LatLng(14.1027670, 120.9509185),
    "Price": 40,
  },
  {
    "Name": "Kanto Kaybagal",
    "LatLng": LatLng(14.1123541, 120.9384414),
    "Price": 40,
  },
  {
    "Name": "Magallanes Square",
    "LatLng": LatLng(14.1027670, 120.9509185),
    "Price": 40,
  },
  {
    "Name": "Richmore Subdivision",
    "LatLng": LatLng(14.1161502, 120.9463926),
    "Price": 40,
  },
  {
    "Name": "Alta Monte Subdivision",
    "LatLng": LatLng(14.1168128, 120.9438884),
    "Price": 40,
  },
  {
    "Name": "Crown Asia",
    "LatLng": LatLng(14.1158769, 120.950534),
    "Price": 40,
  },
  {
    "Name": "Maligaya Market",
    "LatLng": LatLng(14.1109631, 120.9530204),
    "Price": 40,
  },
  {
    "Name": "Canossa",
    "LatLng": LatLng(14.1072342, 120.9548146),
    "Price": 40,
  },
  {
    "Name": "Water District (Via Sta. Rita)",
    "LatLng": LatLng(14.1059028, 120.9407559),
    "Price": 40,
  },
  {
    "Name": "Tagaytay Cemetery",
    "LatLng": LatLng(14.1292220, 120.9470170),
    "Price": 50,
  },
  {
    "Name": "Tagyatay Memorial",
    "LatLng": LatLng(14.1287430, 120.9476540),
    "Price": 50,
  },
  {
    "Name": "SMI (Samuel Mission International School)",
    "LatLng": LatLng(14.1072342, 120.9548146),
    "Price": 60,
  },
  {
    "Name": "TCI",
    "LatLng": LatLng(14.1314354, 120.9569716),
    "Price": 60,
  },
];

// List<TariffsClass> zone2ATagasteFare = zone2ATagasteTerminalFare.map((map) {
//   return TariffsClass(
//       placeName: map['Name'],
//       locationLatLng: map['LatLng'],
//       price: map['Price']);
// }).toList();

const List<Map<String, dynamic>> zone2KantoNBITerminalFare = [
  {
    "Name": "Health Center Main",
    "LatLng": LatLng(14.0999736, 120.9381921),
    "Price": 40,
  },
  {
    "Name": "City Hall",
    "LatLng": LatLng(14.0997167, 120.9383156),
    "Price": 40,
  },
  {
    "Name": "Skyranch",
    "LatLng": LatLng(14.0952777, 120.9377498),
    "Price": 40,
  },
  {
    "Name": "Mahogany Market",
    "LatLng": LatLng(14.1040108, 120.9313761),
    "Price": 40,
  },
  {
    "Name": "Royal Pines East Bukana",
    "LatLng": LatLng(14.1040263, 120.9437090),
    "Price": 40,
  },
  {
    "Name": "Royal Pines East Dulo",
    "LatLng": LatLng(14.1059892, 120.9443648),
    "Price": 50,
  },
  {
    "Name": " Royal Pines West Bukana",
    "LatLng": LatLng(14.1092064, 120.9395269),
    "Price": 40,
  },
  {
    "Name": "Royal Pines West Dulo",
    "LatLng": LatLng(14.1105825, 120.9432801),
    "Price": 50,
  },
  {
    "Name": "Kaybagal Central (Metrogate Labas) Bukana",
    "LatLng": LatLng(14.1147022, 120.9374654),
    "Price": 40,
  },
  {
    "Name": "Kaybagal Central Metrogate Dulo",
    "LatLng": LatLng(14.1144330, 120.9337632),
    "Price": 55,
  },
  {
    "Name": "Metro Gate Phase II Bukana",
    "LatLng": LatLng(14.1170077, 120.9318519),
    "Price": 55,
  },
  {
    "Name": " Metro Gate Phase II Dulo",
    "LatLng": LatLng(14.1199333, 120.9309776),
    "Price": 65,
  },
  {
    "Name": "Daang Luma Central Bukana",
    "LatLng": LatLng(14.1163115, 120.9367814),
    "Price": 40,
  },
  {
    "Name": "Daang Luma Central Dulo",
    "LatLng": LatLng(14.1182838, 120.9361316),
    "Price": 50,
  },
  {
    "Name": " Daang Luma North",
    "LatLng": LatLng(14.1204709, 120.9354856),
    "Price": 50,
  },
  {
    "Name": "Kampo 212 Bukana",
    "LatLng": LatLng(14.1090839, 120.9393239),
    "Price": 40,
  },
  {
    "Name": "Kampo 212 Dulo",
    "LatLng": LatLng(14.1088300, 120.9359999),
    "Price": 50,
  },
  {
    "Name": "Sta. Rita Bukana",
    "LatLng": LatLng(14.1123541, 120.9384414),
    "Price": 40,
  },
  {
    "Name": "Sta. Rita Dulo",
    "LatLng": LatLng(14.1129946, 120.9428705),
    "Price": 50,
  },
  {
    "Name": "JV Homes",
    "LatLng": LatLng(14.1134454, 120.9430205),
    "Price": 50,
  },
  {
    "Name": "Kalye Pogi Bukana",
    "LatLng": LatLng(14.1184282, 120.9366197),
    "Price": 40,
  },
  {
    "Name": "Kalye Pogi Dulo",
    "LatLng": LatLng(14.1187734, 120.9383298),
    "Price": 50,
  },
  {
    "Name": "Kaybagal North Bukana",
    "LatLng": LatLng(14.1200293, 120.9364317),
    "Price": 45,
  },
  {
    "Name": "Kaybagal North Dulo",
    "LatLng": LatLng(14.1200694, 120.9345641),
    "Price": 50,
  },
  {
    "Name": "Kaybagal North (Green Ville loob) Bukana",
    "LatLng": LatLng(14.1219794, 120.9355828),
    "Price": 45,
  },
  {
    "Name": "Kaybagal North (Green Ville loob) Dulo",
    "LatLng": LatLng(14.1235315, 120.9412465),
    "Price": 55,
  },
  {
    "Name": "Pabahay Bukana",
    "LatLng": LatLng(14.1153635, 120.9371419),
    "Price": 40,
  },
  {
    "Name": "Pabahay Dulo",
    "LatLng": LatLng(14.1175537, 120.9340560),
    "Price": 50,
  },
  {
    "Name": "By-pass Road (Tviand)",
    "LatLng": LatLng(14.1257751, 120.9397340),
    "Price": 55,
  }
];

const List<Map<String, dynamic>> ayalaTerminalFare = [
  {
    "Name": "Anya Resort",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 50,
  },
  {
    "Name": "Center",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 70,
  },
  {
    "Name": "Science",
    "LatLng": LatLng(14.1238453, 120.9922370),
    "Price": 70,
  },
  {
    "Name": "Mendoza st.",
    "LatLng": LatLng(14.1249650, 120.9948859),
    "Price": 80,
  },
  {
    "Name": "Picnic",
    "LatLng": LatLng(14.1259746, 120.9970865),
    "Price": 80,
  },
  {
    "Name": "Dap",
    "LatLng": LatLng(14.1257155, 120.9962186),
    "Price": 80,
  },
  {
    "Name": "Bliss",
    "LatLng": LatLng(14.1265249, 120.9976710),
    "Price": 80,
  },
  {
    "Name": "One Bagger",
    "LatLng": LatLng(14.1287917, 121.0006531),
    "Price": 80,
  },
  {
    "Name": "St. Michael",
    "LatLng": LatLng(14.1398640, 120.9907823),
    "Price": 80,
  },
  {
    "Name": "MaryRidge",
    "LatLng": LatLng(14.1290596, 121.0011482),
    "Price": 80,
  },
  {
    "Name": "Kapalaran",
    "LatLng": LatLng(14.1272725, 120.9990677),
    "Price": 80,
  },
  {
    "Name": "Able Site",
    "LatLng": LatLng(14.1295015, 121.0012876),
    "Price": 80,
  },
  {
    "Name": "Kay Payad",
    "LatLng": LatLng(14.1323104, 121.0064155),
    "Price": 100,
  },
  {
    "Name": "Kanto Kabangaan",
    "LatLng": LatLng(14.1318829, 121.0045964),
    "Price": 100,
  },
  {
    "Name": "Bulalong Matanda",
    "LatLng": LatLng(14.1460528, 121.0044399),
    "Price": 100,
  },
  {
    "Name": "Crosswinds",
    "LatLng": LatLng(14.1360794, 121.0111080),
    "Price": 100,
  },
  {
    "Name": " Bulalong Bata",
    "LatLng": LatLng(14.1382647, 120.9997006),
    "Price": 100,
  },
  {
    "Name": " Iruhin central",
    "LatLng": LatLng(14.1382023, 121.0156648),
    "Price": 120,
  },
  {
    "Name": "People\'s Park",
    "LatLng": LatLng(14.1428315, 121.0225003),
    "Price": 150,
  },
  {
    "Name": "Dapdap West",
    "LatLng": LatLng(14.1513610, 121.0140288),
    "Price": 150,
  },
  {
    "Name": "Dapdap East",
    "LatLng": LatLng(14.1546009, 121.0276440),
    "Price": 150,
  },
  {
    "Name": "Calabuso",
    "LatLng": LatLng(14.1467864, 121.0287162),
    "Price": 150,
  },
  {
    "Name": "Mariapolis",
    "LatLng": LatLng(14.1190577, 120.9879081),
    "Price": 70,
  },
  {
    "Name": "Ligaya Drive",
    "LatLng": LatLng(14.1233960, 120.9897068),
    "Price": 70,
  },
  {
    "Name": "Catmon",
    "LatLng": LatLng(14.1185057, 120.9874246),
    "Price": 70,
  },
  {
    "Name": "Bagong Silang",
    "LatLng": LatLng(14.1198454, 120.9858005),
    "Price": 70,
  },
  {
    "Name": "South Ridge",
    "LatLng": LatLng(14.1238166, 120.9913537),
    "Price": 70,
  },
  {
    "Name": "Central",
    "LatLng": LatLng(14.1236152, 120.9895251),
    "Price": 70,
  },
  {
    "Name": "Sta Monica",
    "LatLng": LatLng(14.1258559, 120.9842877),
    "Price": 70,
  },
  {
    "Name": "Marasigan Lane",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 60,
  },
  {
    "Name": "Francisco",
    "LatLng": LatLng(14.1369645, 120.9866239),
    "Price": 70,
  },
  {
    "Name": "Tolentino",
    "LatLng": LatLng(14.1275933, 120.9797253),
    "Price": 70,
  },
  {
    "Name": "City Market",
    "LatLng": LatLng(14.1276363, 120.9802729),
    "Price": 60,
  },
  {
    "Name": "Dominican",
    "LatLng": LatLng(14.1270838, 120.9737129),
    "Price": 40,
  },
  {
    "Name": "St. Gabriel",
    "LatLng": LatLng(14.126487, 120.977440),
    "Price": 60,
  },
  {
    "Name": "Mag-asawang Ilat",
    "LatLng": LatLng(14.1293791, 120.9640769),
    "Price": 60,
  },
  {
    "Name": "Pink Sister",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 50,
  },
  {
    "Name": "Vilbay St",
    "LatLng": LatLng(14.1271764, 120.9582405),
    "Price": 50,
  },
  {
    "Name": "San Jose",
    "LatLng": LatLng(14.1213218, 120.9680338),
    "Price": 40,
  },
  {
    "Name": "Olivarez",
    "LatLng": LatLng(14.1180630, 120.9613108),
    "Price": 40,
  },
  {
    "Name": "Fora",
    "LatLng": LatLng(14.1164853, 120.9611196),
    "Price": 40,
  },
];

const List<Map<String, dynamic>> olivarezTerminalFare = [
  {
    "Name": "ligaya drive",
    "LatLng": LatLng(14.1233960, 120.9897068),
    "Price": 70,
  },
  {
    "Name": "Center",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 70,
  },
  {
    "Name": "Central",
    "LatLng": LatLng(14.1236152, 120.9895251),
    "Price": 70,
  },
  {
    "Name": "Science",
    "LatLng": LatLng(14.1238453, 120.9922370),
    "Price": 70,
  },
  {
    "Name": "Mendoza st.",
    "LatLng": LatLng(14.1249650, 120.9948859),
    "Price": 80,
  },
  {
    "Name": "Picnic",
    "LatLng": LatLng(14.1259746, 120.9970865),
    "Price": 80,
  },
  {
    "Name": "Dap",
    "LatLng": LatLng(14.1257155, 120.9962186),
    "Price": 80,
  },
  {
    "Name": "Bliss",
    "LatLng": LatLng(14.1265249, 120.9976710),
    "Price": 80,
  },
  {
    "Name": "One Bagger",
    "LatLng": LatLng(14.1287917, 121.0006531),
    "Price": 80,
  },
  {
    "Name": "St. Michael",
    "LatLng": LatLng(14.1398640, 120.9907823),
    "Price": 80,
  },
  {
    "Name": "MaryRidge",
    "LatLng": LatLng(14.1290596, 121.0011482),
    "Price": 80,
  },
  {
    "Name": "Kapalaran",
    "LatLng": LatLng(14.1272725, 120.9990677),
    "Price": 80,
  },
  {
    "Name": "Able Site",
    "LatLng": LatLng(14.1295015, 121.0012876),
    "Price": 80,
  },
  {
    "Name": "Kay Payad",
    "LatLng": LatLng(14.1323104, 121.0064155),
    "Price": 100,
  },
  {
    "Name": "Kanto Kabangaan",
    "LatLng": LatLng(14.1318829, 121.0045964),
    "Price": 100,
  },
  {
    "Name": "Kay Payad",
    "LatLng": LatLng(14.1323104, 121.0064155),
    "Price": 100,
  },
  {
    "Name": "Bulalong Matanda",
    "LatLng": LatLng(14.1460528, 121.0044399),
    "Price": 100,
  },
  {
    "Name": "Crosswinds",
    "LatLng": LatLng(14.1360794, 121.0111080),
    "Price": 100,
  },
  {
    "Name": "Bulalong Bata",
    "LatLng": LatLng(14.1382647, 120.9997006),
    "Price": 100,
  },
  {
    "Name": "Iruhin central",
    "LatLng": LatLng(14.1382023, 121.0156648),
    "Price": 120,
  },
  {
    "Name": "people\'s park",
    "LatLng": LatLng(14.1428315, 121.0225003),
    "Price": 150,
  },
  {
    "Name": "Dapdap west",
    "LatLng": LatLng(14.1513610, 121.0140288),
    "Price": 150,
  },
  {
    "Name": "Dapdap East",
    "LatLng": LatLng(14.1546009, 121.0276440),
    "Price": 150,
  },
  {
    "Name": "Calabuso",
    "LatLng": LatLng(14.1467864, 121.0287162),
    "Price": 150,
  },
  {
    "Name": "ligaya dive",
    "LatLng": LatLng(14.1233960, 120.9897068),
    "Price": 70,
  },
  {
    "Name": "Mariapolis",
    "LatLng": LatLng(14.1190577, 120.9879081),
    "Price": 70,
  },
  {
    "Name": "Catmon",
    "LatLng": LatLng(14.1185057, 120.9874246),
    "Price": 70,
  },
  {
    "Name": "Bagong Silang",
    "LatLng": LatLng(14.1198454, 120.9858005),
    "Price": 70,
  },
  {
    "Name": "Sta Monica",
    "LatLng": LatLng(14.1258559, 120.9842877),
    "Price": 70,
  },
  {
    "Name": "Marasigan Lane",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 70,
  },
  {
    "Name": "Francisco",
    "LatLng": LatLng(14.1369645, 120.9866239),
    "Price": 70,
  },
  {
    "Name": "Tolentino",
    "LatLng": LatLng(14.1275933, 120.9797253),
    "Price": 70,
  },
  {
    "Name": "city market",
    "LatLng": LatLng(14.1276363, 120.9802729),
    "Price": 60,
  },
  {
    "Name": "Dominican",
    "LatLng": LatLng(14.1270838, 120.9737129),
    "Price": 40,
  },
  {
    "Name": "st. gabriel",
    "LatLng": LatLng(14.126487, 120.977440),
    "Price": 60,
  },
  {
    "Name": "mag-asawang ilat",
    "LatLng": LatLng(14.1293791, 120.9640769),
    "Price": 70,
  },
  {
    "Name": "San jose",
    "LatLng": LatLng(14.1213218, 120.9680338),
    "Price": 40,
  },
];

const List<Map<String, dynamic>> dominicanTerminalFare = [
  {
    "Name": "Anya Resort",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 40,
  },
  {
    "Name": "Center",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 60,
  },
  {
    "Name": "Science",
    "LatLng": LatLng(14.1238453, 120.9922370),
    "Price": 60,
  },
  {
    "Name": "Central",
    "LatLng": LatLng(14.1236152, 120.9895251),
    "Price": 60,
  },
  {
    "Name": "ligaya dive",
    "LatLng": LatLng(14.1233960, 120.9897068),
    "Price": 60,
  },
  {
    "Name": "Mendoza st.",
    "LatLng": LatLng(14.1249650, 120.9948859),
    "Price": 70,
  },
  {
    "Name": "Picnic",
    "LatLng": LatLng(14.1259746, 120.9970865),
    "Price": 70,
  },
  {
    "Name": "Dap",
    "LatLng": LatLng(14.1257155, 120.9962186),
    "Price": 70,
  },
  {
    "Name": "Bliss",
    "LatLng": LatLng(14.1265249, 120.9976710),
    "Price": 70,
  },
  {
    "Name": "One Bagger",
    "LatLng": LatLng(14.1287917, 121.0006531),
    "Price": 70,
  },
  {
    "Name": "St. Michael",
    "LatLng": LatLng(14.1398640, 120.9907823),
    "Price": 70,
  },
  {
    "Name": "MaryRidge",
    "LatLng": LatLng(14.1290596, 121.0011482),
    "Price": 70,
  },
  {
    "Name": "Kapalaran",
    "LatLng": LatLng(14.1272725, 120.9990677),
    "Price": 70,
  },
  {
    "Name": "Able Site",
    "LatLng": LatLng(14.1295015, 121.0012876),
    "Price": 50,
  },
  {
    "Name": "Kay Payad",
    "LatLng": LatLng(14.1323104, 121.0064155),
    "Price": 90,
  },
  {
    "Name": "Kanto Kabangaan",
    "LatLng": LatLng(14.1318829, 121.0045964),
    "Price": 90,
  },
  {
    "Name": "Bulalong Matanda",
    "LatLng": LatLng(14.1460528, 121.0044399),
    "Price": 90,
  },
  {
    "Name": "Crosswinds",
    "LatLng": LatLng(14.1360794, 121.0111080),
    "Price": 90,
  },
  {
    "Name": "Bulalong Bata",
    "LatLng": LatLng(14.1382647, 120.9997006),
    "Price": 90,
  },
  {
    "Name": "Iruhin central",
    "LatLng": LatLng(14.1382023, 121.0156648),
    "Price": 100,
  },
  {
    "Name": "people\'s park",
    "LatLng": LatLng(14.1428315, 121.0225003),
    "Price": 120,
  },
  {
    "Name": "Dapdap west",
    "LatLng": LatLng(14.1513610, 121.0140288),
    "Price": 120,
  },
  {
    "Name": "Dapdap East",
    "LatLng": LatLng(14.1546009, 121.0276440),
    "Price": 130,
  },
  {
    "Name": "Calabuso",
    "LatLng": LatLng(14.1467864, 121.0287162),
    "Price": 120,
  },
  {
    "Name": "ligaya dive",
    "LatLng": LatLng(14.1233960, 120.9897068),
    "Price": 60,
  },
  {
    "Name": "Mariapolis",
    "LatLng": LatLng(14.1190577, 120.9879081),
    "Price": 60,
  },
  {
    "Name": "Catmon",
    "LatLng": LatLng(14.1185057, 120.9874246),
    "Price": 60,
  },
  {
    "Name": "Bagong Silang",
    "LatLng": LatLng(14.1198454, 120.9858005),
    "Price": 60,
  },
  {
    "Name": "south ridge",
    "LatLng": LatLng(14.1238166, 120.9913537),
    "Price": 760,
  },
  {
    "Name": "Central",
    "LatLng": LatLng(14.1236152, 120.9895251),
    "Price": 60,
  },
  {
    "Name": "Sta Monica",
    "LatLng": LatLng(14.1258559, 120.9842877),
    "Price": 50,
  },
  {
    "Name": "Marasigan Lane",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 50,
  },
  {
    "Name": "Francisco",
    "LatLng": LatLng(14.1369645, 120.9866239),
    "Price": 50,
  },
  {
    "Name": "Tolentino",
    "LatLng": LatLng(14.1275933, 120.9797253),
    "Price": 50,
  },
  {
    "Name": "city market",
    "LatLng": LatLng(14.1276363, 120.9802729),
    "Price": 40,
  },
  {
    "Name": "Dominican",
    "LatLng": LatLng(14.1270838, 120.9737129),
    "Price": 60,
  },
  {
    "Name": "st. gabriel",
    "LatLng": LatLng(14.126487, 120.977440),
    "Price": 60,
  },
  {
    "Name": "mag-asawang ilat",
    "LatLng": LatLng(14.1293791, 120.9640769),
    "Price": 50,
  },
  {
    "Name": "pink sister",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 60,
  },
  {
    "Name": "vilbay st",
    "LatLng": LatLng(14.1271764, 120.9582405),
    "Price": 60,
  },
  {
    "Name": "San jose",
    "LatLng": LatLng(14.1213218, 120.9680338),
    "Price": 40,
  },
  {
    "Name": "olivarez",
    "LatLng": LatLng(14.1180630, 120.9613108),
    "Price": 50,
  },
  {
    "Name": "Fora",
    "LatLng": LatLng(14.1164853, 120.9611196),
    "Price": 50,
  },
  {
    "Name": "ayala",
    "LatLng": LatLng(14.1133006, 120.9595693),
    "Price": 50,
  },
];

const List<Map<String, dynamic>> foraTerminalFare = [
  {
    "Name": "Anya Resort",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 50,
  },
  {
    "Name": "Center",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 70,
  },
  {
    "Name": "Central",
    "LatLng": LatLng(14.1236152, 120.9895251),
    "Price": 70,
  },
  {
    "Name": "ligaya dive",
    "LatLng": LatLng(14.1233960, 120.9897068),
    "Price": 70,
  },
  {
    "Name": "Science",
    "LatLng": LatLng(14.1238453, 120.9922370),
    "Price": 70,
  },
  {
    "Name": "Mendoza st.",
    "LatLng": LatLng(14.1249650, 120.9948859),
    "Price": 80,
  },
  {
    "Name": "Picnic",
    "LatLng": LatLng(14.1259746, 120.9970865),
    "Price": 80,
  },
  {
    "Name": "Dap",
    "LatLng": LatLng(14.1257155, 120.9962186),
    "Price": 80,
  },
  {
    "Name": "Bliss",
    "LatLng": LatLng(14.1265249, 120.9976710),
    "Price": 80,
  },
  {
    "Name": "One Bagger",
    "LatLng": LatLng(14.1287917, 121.0006531),
    "Price": 80,
  },
  {
    "Name": "St. Michael",
    "LatLng": LatLng(14.1398640, 120.9907823),
    "Price": 80,
  },
  {
    "Name": "MaryRidge",
    "LatLng": LatLng(14.1290596, 121.0011482),
    "Price": 70,
  },
  {
    "Name": "Kapalaran",
    "LatLng": LatLng(14.1272725, 120.9990677),
    "Price": 80,
  },
  {
    "Name": "Able Site",
    "LatLng": LatLng(14.1295015, 121.0012876),
    "Price": 80,
  },
  {
    "Name": "Kay Payad",
    "LatLng": LatLng(14.1323104, 121.0064155),
    "Price": 90,
  },
  {
    "Name": "Kanto Kabangaan",
    "LatLng": LatLng(14.1318829, 121.0045964),
    "Price": 90,
  },
  {
    "Name": "Bulalong Matanda",
    "LatLng": LatLng(14.1460528, 121.0044399),
    "Price": 100,
  },
  {
    "Name": "Crosswinds",
    "LatLng": LatLng(14.1360794, 121.0111080),
    "Price": 100,
  },
  {
    "Name": "Bulalong Bata",
    "LatLng": LatLng(14.1382647, 120.9997006),
    "Price": 100,
  },
  {
    "Name": "Iruhin central",
    "LatLng": LatLng(14.1382023, 121.0156648),
    "Price": 120,
  },
  {
    "Name": " people\'s park",
    "LatLng": LatLng(14.1428315, 121.0225003),
    "Price": 150,
  },
  {
    "Name": "Dapdap west",
    "LatLng": LatLng(14.1513610, 121.0140288),
    "Price": 150,
  },
  {
    "Name": "Dapdap East",
    "LatLng": LatLng(14.1546009, 121.0276440),
    "Price": 130,
  },
  {
    "Name": "Calabuso",
    "LatLng": LatLng(14.1467864, 121.0287162),
    "Price": 150,
  },
  {
    "Name": "Mariapolis",
    "LatLng": LatLng(14.1190577, 120.9879081),
    "Price": 70,
  },
  {
    "Name": "Catmon",
    "LatLng": LatLng(14.1185057, 120.9874246),
    "Price": 70,
  },
  {
    "Name": "Bagong Silang",
    "LatLng": LatLng(14.1198454, 120.9858005),
    "Price": 70,
  },
  {
    "Name": "south ridge",
    "LatLng": LatLng(14.1238166, 120.9913537),
    "Price": 70,
  },
  {
    "Name": "Central",
    "LatLng": LatLng(14.1236152, 120.9895251),
    "Price": 70,
  },
  {
    "Name": "Sta Monica",
    "LatLng": LatLng(14.1258559, 120.9842877),
    "Price": 70,
  },
  {
    "Name": "Marasigan Lane",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 60,
  },
  {
    "Name": "Francisco",
    "LatLng": LatLng(14.1369645, 120.9866239),
    "Price": 70,
  },
  {
    "Name": "Tolentino",
    "LatLng": LatLng(14.1275933, 120.9797253),
    "Price": 70,
  },
  {
    "Name": "city market",
    "LatLng": LatLng(14.1276363, 120.9802729),
    "Price": 60,
  },
  {
    "Name": "Dominican",
    "LatLng": LatLng(14.1270838, 120.9737129),
    "Price": 40,
  },
  {
    "Name": "st. gabriel",
    "LatLng": LatLng(14.126487, 120.977440),
    "Price": 60,
  },
  {
    "Name": "mag-asawang ilat",
    "LatLng": LatLng(14.1293791, 120.9640769),
    "Price": 50,
  },
  {
    "Name": "pink sister",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 50,
  },
  {
    "Name": "vilbay st",
    "LatLng": LatLng(14.1271764, 120.9582405),
    "Price": 50,
  },
  {
    "Name": "San jose",
    "LatLng": LatLng(14.1213218, 120.9680338),
    "Price": 40,
  },
  {
    "Name": "olivarez",
    "LatLng": LatLng(14.1180630, 120.9613108),
    "Price": 40,
  },
  {
    "Name": "ayala",
    "LatLng": LatLng(14.1133006, 120.9595693),
    "Price": 40,
  },
];

const List<Map<String, dynamic>> citymarketTerminalFare = [
  {
    "Name": "Anya Resort",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 40,
  },
  {
    "Name": "Center",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 50,
  },
  {
    "Name": "Science",
    "LatLng": LatLng(14.1238453, 120.9922370),
    "Price": 50,
  },
  {
    "Name": "Mendoza st.",
    "LatLng": LatLng(14.1249650, 120.9948859),
    "Price": 50,
  },
  {
    "Name": "Picnic",
    "LatLng": LatLng(14.1259746, 120.9970865),
    "Price": 50,
  },
  {
    "Name": "Dap",
    "LatLng": LatLng(14.1257155, 120.9962186),
    "Price": 50,
  },
  {
    "Name": "Bliss",
    "LatLng": LatLng(14.1265249, 120.9976710),
    "Price": 50,
  },
  {
    "Name": "One Bagger",
    "LatLng": LatLng(14.1287917, 121.0006531),
    "Price": 60,
  },
  {
    "Name": "St. Michael",
    "LatLng": LatLng(14.1398640, 120.9907823),
    "Price": 70,
  },
  {
    "Name": "MaryRidge",
    "LatLng": LatLng(14.1290596, 121.0011482),
    "Price": 60,
  },
  {
    "Name": "Kapalaran",
    "LatLng": LatLng(14.1272725, 120.9990677),
    "Price": 60,
  },
  {
    "Name": "Able Site",
    "LatLng": LatLng(14.1295015, 121.0012876),
    "Price": 60,
  },
  {
    "Name": "Kay Payad",
    "LatLng": LatLng(14.1323104, 121.0064155),
    "Price": 70,
  },
  {
    "Name": "Kanto Kabangaan",
    "LatLng": LatLng(14.1318829, 121.0045964),
    "Price": 70,
  },
  {
    "Name": "Bulalong Matanda",
    "LatLng": LatLng(14.1460528, 121.0044399),
    "Price": 70,
  },
  {
    "Name": "Crosswinds",
    "LatLng": LatLng(14.1360794, 121.0111080),
    "Price": 70,
  },
  {
    "Name": "Bulalong Bata",
    "LatLng": LatLng(14.1382647, 120.9997006),
    "Price": 70,
  },
  {
    "Name": "Iruhin central",
    "LatLng": LatLng(14.1382023, 121.0156648),
    "Price": 70,
  },
  {
    "Name": "people\'s park",
    "LatLng": LatLng(14.1428315, 121.0225003),
    "Price": 80,
  },
  {
    "Name": "Dapdap west",
    "LatLng": LatLng(14.1513610, 121.0140288),
    "Price": 80,
  },
  {
    "Name": "Dapdap East",
    "LatLng": LatLng(14.1546009, 121.0276440),
    "Price": 100,
  },
  {
    "Name": "Calabuso",
    "LatLng": LatLng(14.1467864, 121.0287162),
    "Price": 80,
  },
  {
    "Name": "Mariapolis",
    "LatLng": LatLng(14.1190577, 120.9879081),
    "Price": 50,
  },
  {
    "Name": "ligaya dive",
    "LatLng": LatLng(14.1233960, 120.9897068),
    "Price": 50,
  },
  {
    "Name": "Catmon",
    "LatLng": LatLng(14.1185057, 120.9874246),
    "Price": 50,
  },
  {
    "Name": "Bagong Silang",
    "LatLng": LatLng(14.1198454, 120.9858005),
    "Price": 50,
  },
  {
    "Name": "south ridge",
    "LatLng": LatLng(14.1238166, 120.9913537),
    "Price": 50,
  },
  {
    "Name": "Central",
    "LatLng": LatLng(14.1236152, 120.9895251),
    "Price": 50,
  },
  {
    "Name": "Sta Monica",
    "LatLng": LatLng(14.1258559, 120.9842877),
    "Price": 40,
  },
  {
    "Name": "Marasigan Lane",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 40,
  },
  {
    "Name": "Francisco",
    "LatLng": LatLng(14.1369645, 120.9866239),
    "Price": 40,
  },
  {
    "Name": "Tolentino",
    "LatLng": LatLng(14.1275933, 120.9797253),
    "Price": 40,
  },
  {
    "Name": "Dominican",
    "LatLng": LatLng(14.1270838, 120.9737129),
    "Price": 40,
  },
  {
    "Name": "st. gabriel",
    "LatLng": LatLng(14.126487, 120.977440),
    "Price": 40,
  },
  {
    "Name": "mag-asawang ilat",
    "LatLng": LatLng(14.1293791, 120.9640769),
    "Price": 70,
  },
  {
    "Name": "SVD",
    "LatLng": LatLng(14.1275568, 120.9649262),
    "Price": 70,
  },
  {
    "Name": "pink sister",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 70,
  },
  {
    "Name": "vilbay st",
    "LatLng": LatLng(14.1271764, 120.9582405),
    "Price": 70,
  },
  {
    "Name": "San jose",
    "LatLng": LatLng(14.1213218, 120.9680338),
    "Price": 60,
  },
  {
    "Name": "olivarez",
    "LatLng": LatLng(14.1180630, 120.9613108),
    "Price": 60,
  },
  {
    "Name": "Fora",
    "LatLng": LatLng(14.1164853, 120.9611196),
    "Price": 60,
  },
  {
    "Name": "Ayala",
    "LatLng": LatLng(14.1133006, 120.9595693),
    "Price": 60,
  },
];

const List<Map<String, dynamic>> tolentinoTerminalFare = [
  {
    "Name": "Anya Resort",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 40,
  },
  {
    "Name": "Center",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 50,
  },
  {
    "Name": "Science",
    "LatLng": LatLng(14.1238453, 120.9922370),
    "Price": 50,
  },
  {
    "Name": "Mendoza st.",
    "LatLng": LatLng(14.1249650, 120.9948859),
    "Price": 50,
  },
  {
    "Name": "Picnic",
    "LatLng": LatLng(14.1259746, 120.9970865),
    "Price": 50,
  },
  {
    "Name": "Dap",
    "LatLng": LatLng(14.1257155, 120.9962186),
    "Price": 50,
  },
  {
    "Name": "Bliss",
    "LatLng": LatLng(14.1265249, 120.9976710),
    "Price": 50,
  },
  {
    "Name": "One Bagger",
    "LatLng": LatLng(14.1287917, 121.0006531),
    "Price": 60,
  },
  {
    "Name": "St. Michael",
    "LatLng": LatLng(14.1398640, 120.9907823),
    "Price": 70,
  },
  {
    "Name": "MaryRidge",
    "LatLng": LatLng(14.1290596, 121.0011482),
    "Price": 60,
  },
  {
    "Name": "Kapalaran",
    "LatLng": LatLng(14.1272725, 120.9990677),
    "Price": 60,
  },
  {
    "Name": "Able Site",
    "LatLng": LatLng(14.1295015, 121.0012876),
    "Price": 60,
  },
  {
    "Name": "Kay Payad",
    "LatLng": LatLng(14.1323104, 121.0064155),
    "Price": 70,
  },
  {
    "Name": "Kanto Kabangaan",
    "LatLng": LatLng(14.1318829, 121.0045964),
    "Price": 70,
  },
  {
    "Name": "Bulalong Matanda",
    "LatLng": LatLng(14.1460528, 121.0044399),
    "Price": 70,
  },
  {
    "Name": "Crosswinds",
    "LatLng": LatLng(14.1360794, 121.0111080),
    "Price": 70,
  },
  {
    "Name": "Bulalong Bata",
    "LatLng": LatLng(14.1382647, 120.9997006),
    "Price": 70,
  },
  {
    "Name": "Iruhin central",
    "LatLng": LatLng(14.1382023, 121.0156648),
    "Price": 70,
  },
  {
    "Name": "people\'s park",
    "LatLng": LatLng(14.1428315, 121.0225003),
    "Price": 80,
  },
  {
    "Name": "Dapdap west",
    "LatLng": LatLng(14.1513610, 121.0140288),
    "Price": 80,
  },
  {
    "Name": "Dapdap East",
    "LatLng": LatLng(14.1546009, 121.0276440),
    "Price": 100,
  },
  {
    "Name": "Calabuso",
    "LatLng": LatLng(14.1467864, 121.0287162),
    "Price": 80,
  },
  {
    "Name": "Mariapolis",
    "LatLng": LatLng(14.1190577, 120.9879081),
    "Price": 50,
  },
  {
    "Name": "ligaya dive",
    "LatLng": LatLng(14.1233960, 120.9897068),
    "Price": 50,
  },
  {
    "Name": "Catmon",
    "LatLng": LatLng(14.1185057, 120.9874246),
    "Price": 50,
  },
  {
    "Name": "Bagong Silang",
    "LatLng": LatLng(14.1198454, 120.9858005),
    "Price": 50,
  },
  {
    "Name": "south ridge",
    "LatLng": LatLng(14.1238166, 120.9913537),
    "Price": 50,
  },
  {
    "Name": "Central",
    "LatLng": LatLng(14.1236152, 120.9895251),
    "Price": 50,
  },
  {
    "Name": "Sta Monica",
    "LatLng": LatLng(14.1258559, 120.9842877),
    "Price": 40,
  },
  {
    "Name": "Marasigan Lane",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 40,
  },
  {
    "Name": "Francisco",
    "LatLng": LatLng(14.1369645, 120.9866239),
    "Price": 40,
  },
  {
    "Name": "Tolentino",
    "LatLng": LatLng(14.1275933, 120.9797253),
    "Price": 40,
  },
  {
    "Name": "Dominican",
    "LatLng": LatLng(14.1270838, 120.9737129),
    "Price": 40,
  },
  {
    "Name": "St. gabriel",
    "LatLng": LatLng(14.126487, 120.977440),
    "Price": 40,
  },
  {
    "Name": "mag-asawang ilat",
    "LatLng": LatLng(14.1293791, 120.9640769),
    "Price": 70,
  },
  {
    "Name": "SVD",
    "LatLng": LatLng(14.1275568, 120.9649262),
    "Price": 70,
  },
  {
    "Name": "pink sister",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 70,
  },
  {
    "Name": "vilbay st",
    "LatLng": LatLng(14.1271764, 120.9582405),
    "Price": 70,
  },
  {
    "Name": "San jose",
    "LatLng": LatLng(14.1213218, 120.9680338),
    "Price": 60,
  },
  {
    "Name": "olivarez",
    "LatLng": LatLng(14.1180630, 120.9613108),
    "Price": 60,
  },
  {
    "Name": "Fora",
    "LatLng": LatLng(14.1164853, 120.9611196),
    "Price": 60,
  },
  {
    "Name": "ayala",
    "LatLng": LatLng(14.1133006, 120.9595693),
    "Price": 60,
  },
];

const List<Map<String, dynamic>> wetMarketTerminalFare = [
  {
    "Name": "Anya Resort",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 40,
  },
  {
    "Name": "Center",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 50,
  },
  {
    "Name": "Science",
    "LatLng": LatLng(14.1238453, 120.9922370),
    "Price": 50,
  },
  {
    "Name": "Mendoza st.",
    "LatLng": LatLng(14.1249650, 120.9948859),
    "Price": 50,
  },
  {
    "Name": "Picnic",
    "LatLng": LatLng(14.1259746, 120.9970865),
    "Price": 50,
  },
  {
    "Name": "Dap",
    "LatLng": LatLng(14.1257155, 120.9962186),
    "Price": 50,
  },
  {
    "Name": "Bliss",
    "LatLng": LatLng(14.1265249, 120.9976710),
    "Price": 50,
  },
  {
    "Name": "One Bagger",
    "LatLng": LatLng(14.1287917, 121.0006531),
    "Price": 60,
  },
  {
    "Name": "St. Michael",
    "LatLng": LatLng(14.1398640, 120.9907823),
    "Price": 70,
  },
  {
    "Name": "MaryRidge",
    "LatLng": LatLng(14.1290596, 121.0011482),
    "Price": 60,
  },
  {
    "Name": "Kapalaran",
    "LatLng": LatLng(14.1272725, 120.9990677),
    "Price": 60,
  },
  {
    "Name": "Able Site",
    "LatLng": LatLng(14.1295015, 121.0012876),
    "Price": 60,
  },
  {
    "Name": "Kay Payad",
    "LatLng": LatLng(14.1323104, 121.0064155),
    "Price": 70,
  },
  {
    "Name": "Kanto Kabangaan",
    "LatLng": LatLng(14.1318829, 121.0045964),
    "Price": 70,
  },
  {
    "Name": "Bulalong Matanda",
    "LatLng": LatLng(14.1460528, 121.0044399),
    "Price": 70,
  },
  {
    "Name": "Crosswinds",
    "LatLng": LatLng(14.1360794, 121.0111080),
    "Price": 70,
  },
  {
    "Name": "Bulalong Bata",
    "LatLng": LatLng(14.1382647, 120.9997006),
    "Price": 70,
  },
  {
    "Name": "Iruhin central",
    "LatLng": LatLng(14.1382023, 121.0156648),
    "Price": 70,
  },
  {
    "Name": "people\'s park",
    "LatLng": LatLng(14.1428315, 121.0225003),
    "Price": 80,
  },
  {
    "Name": "Dapdap west",
    "LatLng": LatLng(14.1513610, 121.0140288),
    "Price": 80,
  },
  {
    "Name": "Dapdap East",
    "LatLng": LatLng(14.1546009, 121.0276440),
    "Price": 100,
  },
  {
    "Name": "Calabuso",
    "LatLng": LatLng(14.1467864, 121.0287162),
    "Price": 80,
  },
  {
    "Name": "Mariapolis",
    "LatLng": LatLng(14.1190577, 120.9879081),
    "Price": 50,
  },
  {
    "Name": "ligaya dive",
    "LatLng": LatLng(14.1233960, 120.9897068),
    "Price": 50,
  },
  {
    "Name": "Catmon",
    "LatLng": LatLng(14.1185057, 120.9874246),
    "Price": 50,
  },
  {
    "Name": "Bagong Silang",
    "LatLng": LatLng(14.1198454, 120.9858005),
    "Price": 50,
  },
  {
    "Name": "south ridge",
    "LatLng": LatLng(14.1238166, 120.9913537),
    "Price": 50,
  },
  {
    "Name": "Central",
    "LatLng": LatLng(14.1236152, 120.9895251),
    "Price": 50,
  },
  {
    "Name": "Sta Monica",
    "LatLng": LatLng(14.1258559, 120.9842877),
    "Price": 40,
  },
  {
    "Name": "Marasigan Lane",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 40,
  },
  {
    "Name": "Francisco",
    "LatLng": LatLng(14.1369645, 120.9866239),
    "Price": 40,
  },
  {
    "Name": "Tolentino",
    "LatLng": LatLng(14.1275933, 120.9797253),
    "Price": 40,
  },
  {
    "Name": "Dominican",
    "LatLng": LatLng(14.1270838, 120.9737129),
    "Price": 40,
  },
  {
    "Name": "st. gabriel",
    "LatLng": LatLng(14.126487, 120.977440),
    "Price": 40,
  },
  {
    "Name": "mag-asawang ilat",
    "LatLng": LatLng(14.1293791, 120.9640769),
    "Price": 70,
  },
  {
    "Name": "SVD",
    "LatLng": LatLng(14.1275568, 120.9649262),
    "Price": 70,
  },
  {
    "Name": "pink sister",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 70,
  },
  {
    "Name": "vilbay st",
    "LatLng": LatLng(14.1271764, 120.9582405),
    "Price": 70,
  },
  {
    "Name": "San jose",
    "LatLng": LatLng(14.1213218, 120.9680338),
    "Price": 60,
  },
  {
    "Name": "olivarez",
    "LatLng": LatLng(14.1180630, 120.9613108),
    "Price": 60,
  },
  {
    "Name": "Fora",
    "LatLng": LatLng(14.1164853, 120.9611196),
    "Price": 60,
  },
  {
    "Name": "ayala",
    "LatLng": LatLng(14.1133006, 120.9595693),
    "Price": 60,
  },
];

const List<Map<String, dynamic>> grandTerminalMarketTerminalFare = [
  {
    "Name": "Anya Resort",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 40,
  },
  {
    "Name": "Center",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 70,
  },
  {
    "Name": "Science",
    "LatLng": LatLng(14.1238453, 120.9922370),
    "Price": 70,
  },
  {
    "Name": "Mendoza st.",
    "LatLng": LatLng(14.1249650, 120.9948859),
    "Price": 80,
  },
  {
    "Name": "Picnic",
    "LatLng": LatLng(14.1259746, 120.9970865),
    "Price": 80,
  },
  {
    "Name": "Dap",
    "LatLng": LatLng(14.1257155, 120.9962186),
    "Price": 80,
  },
  {
    "Name": "Bliss",
    "LatLng": LatLng(14.1265249, 120.9976710),
    "Price": 80,
  },
  {
    "Name": "One Bagger",
    "LatLng": LatLng(14.1287917, 121.0006531),
    "Price": 80,
  },
  {
    "Name": "St. Michael",
    "LatLng": LatLng(14.1398640, 120.9907823),
    "Price": 80,
  },
  {
    "Name": "MaryRidge",
    "LatLng": LatLng(14.1290596, 121.0011482),
    "Price": 80,
  },
  {
    "Name": "Kapalaran",
    "LatLng": LatLng(14.1272725, 120.9990677),
    "Price": 80,
  },
  {
    "Name": "Able Site",
    "LatLng": LatLng(14.1295015, 121.0012876),
    "Price": 80,
  },
  {
    "Name": "Kay Payad",
    "LatLng": LatLng(14.1323104, 121.0064155),
    "Price": 100,
  },
  {
    "Name": "Kanto Kabangaan",
    "LatLng": LatLng(14.1318829, 121.0045964),
    "Price": 100,
  },
  {
    "Name": "Bulalong Matanda",
    "LatLng": LatLng(14.1460528, 121.0044399),
    "Price": 100,
  },
  {
    "Name": "Crosswinds",
    "LatLng": LatLng(14.1360794, 121.0111080),
    "Price": 100,
  },
  {
    "Name": "Bulalong Bata",
    "LatLng": LatLng(14.1382647, 120.9997006),
    "Price": 100,
  },
  {
    "Name": "Iruhin central",
    "LatLng": LatLng(14.1382023, 121.0156648),
    "Price": 120,
  },
  {
    "Name": "people's park",
    "LatLng": LatLng(14.1428315, 121.0225003),
    "Price": 150,
  },
  {
    "Name": "Dapdap west",
    "LatLng": LatLng(14.1513610, 121.0140288),
    "Price": 150,
  },
  {
    "Name": "Dapdap East",
    "LatLng": LatLng(14.1546009, 121.0276440),
    "Price": 150,
  },
  {
    "Name": "Calabuso",
    "LatLng": LatLng(14.1467864, 121.0287162),
    "Price": 150,
  },
  {
    "Name": "Mariapolis",
    "LatLng": LatLng(14.1190577, 120.9879081),
    "Price": 70,
  },
  {
    "Name": "ligaya dive",
    "LatLng": LatLng(14.1233960, 120.9897068),
    "Price": 70,
  },
  {
    "Name": "Catmon",
    "LatLng": LatLng(14.1185057, 120.9874246),
    "Price": 70,
  },
  {
    "Name": "Bagong Silang",
    "LatLng": LatLng(14.1198454, 120.9858005),
    "Price": 70,
  },
  {
    "Name": "south ridge",
    "LatLng": LatLng(14.1238166, 120.9913537),
    "Price": 70,
  },
  {
    "Name": "Central",
    "LatLng": LatLng(14.1236152, 120.9895251),
    "Price": 70,
  },
  {
    "Name": "Sta Monica",
    "LatLng": LatLng(14.1258559, 120.9842877),
    "Price": 700,
  },
  {
    "Name": "Marasigan Lane",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 60,
  },
  {
    "Name": "Francisco",
    "LatLng": LatLng(14.1369645, 120.9866239),
    "Price": 70,
  },
  {
    "Name": "Tolentino",
    "LatLng": LatLng(14.1275933, 120.9797253),
    "Price": 70,
  },
  {
    "Name": "Dominican",
    "LatLng": LatLng(14.1270838, 120.9737129),
    "Price": 40,
  },
  {
    "Name": "st. gabriel",
    "LatLng": LatLng(14.126487, 120.977440),
    "Price": 40,
  },
  {
    "Name": "mag-asawang ilat",
    "LatLng": LatLng(14.1293791, 120.9640769),
    "Price": 50,
  },
  {
    "Name": "SVD",
    "LatLng": LatLng(14.1275568, 120.9649262),
    "Price": 50,
  },
  {
    "Name": "pink sister",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 40,
  },
  {
    "Name": "vilbay st",
    "LatLng": LatLng(14.1271764, 120.9582405),
    "Price": 40,
  },
  {
    "Name": "San jose",
    "LatLng": LatLng(14.1213218, 120.9680338),
    "Price": 60,
  },
  {
    "Name": "olivarez",
    "LatLng": LatLng(14.1180630, 120.9613108),
    "Price": 50,
  },
  {
    "Name": "Fora",
    "LatLng": LatLng(14.1164853, 120.9611196),
    "Price": 40,
  },
  {
    "Name": "ayala",
    "LatLng": LatLng(14.1133006, 120.9595693),
    "Price": 40,
  },
];

const List<Map<String, dynamic>> LigayaDriveTerminalFare = [
  {
    "Name": "Center",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 40,
  },
  {
    "Name": "Science",
    "LatLng": LatLng(14.1238453, 120.9922370),
    "Price": 40,
  },
  {
    "Name": "Mendoza st.",
    "LatLng": LatLng(14.1249650, 120.9948859),
    "Price": 50,
  },
  {
    "Name": "Picnic",
    "LatLng": LatLng(14.1259746, 120.9970865),
    "Price": 50,
  },
  {
    "Name": "Dap",
    "LatLng": LatLng(14.1257155, 120.9962186),
    "Price": 50,
  },
  {
    "Name": "Bliss",
    "LatLng": LatLng(14.1265249, 120.9976710),
    "Price": 50,
  },
  {
    "Name": "One Bagger",
    "LatLng": LatLng(14.1287917, 121.0006531),
    "Price": 50,
  },
  {
    "Name": "St. Michael",
    "LatLng": LatLng(14.1398640, 120.9907823),
    "Price": 50,
  },
  {
    "Name": "MaryRidge",
    "LatLng": LatLng(14.1290596, 121.0011482),
    "Price": 40,
  },
  {
    "Name": "Kapalaran",
    "LatLng": LatLng(14.1272725, 120.9990677),
    "Price": 50,
  },
  {
    "Name": "Able Site",
    "LatLng": LatLng(14.1295015, 121.0012876),
    "Price": 50,
  },
  {
    "Name": "Kanto Kabangaan",
    "LatLng": LatLng(14.1318829, 121.0045964),
    "Price": 60,
  },
  {
    "Name": "Kay Payad",
    "LatLng": LatLng(14.1323104, 121.0064155),
    "Price": 70,
  },
  {
    "Name": "Bulalong Matanda",
    "LatLng": LatLng(14.1460528, 121.0044399),
    "Price": 70,
  },
  {
    "Name": "Crosswinds",
    "LatLng": LatLng(14.1360794, 121.0111080),
    "Price": 70,
  },
  {
    "Name": "Bulalong Bata",
    "LatLng": LatLng(14.1382647, 120.9997006),
    "Price": 60,
  },
  {
    "Name": "Iruhin central",
    "LatLng": LatLng(14.1382023, 121.0156648),
    "Price": 70,
  },
  {
    "Name": "people\'s park",
    "LatLng": LatLng(14.1428315, 121.0225003),
    "Price": 80,
  },
  {
    "Name": "Dapdap west",
    "LatLng": LatLng(14.1513610, 121.0140288),
    "Price": 80,
  },
  {
    "Name": "Dapdap East",
    "LatLng": LatLng(14.1546009, 121.0276440),
    "Price": 100,
  },
  {
    "Name": "Calabuso",
    "LatLng": LatLng(14.1467864, 121.0287162),
    "Price": 80,
  },
  {
    "Name": "Mariapolis",
    "LatLng": LatLng(14.1190577, 120.9879081),
    "Price": 40,
  },
  {
    "Name": "Catmon",
    "LatLng": LatLng(14.1185057, 120.9874246),
    "Price": 40,
  },
  {
    "Name": "Bagong Silang",
    "LatLng": LatLng(14.1198454, 120.9858005),
    "Price": 40,
  },
  {
    "Name": "Sta Monica",
    "LatLng": LatLng(14.1258559, 120.9842877),
    "Price": 40,
  },
  {
    "Name": "Marasigan Lane",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 40,
  },
  {
    "Name": "Francisco",
    "LatLng": LatLng(14.1369645, 120.9866239),
    "Price": 50,
  },
  {
    "Name": "Tolentino",
    "LatLng": LatLng(14.1275933, 120.9797253),
    "Price": 50,
  },
  {
    "Name": "city market",
    "LatLng": LatLng(14.1276363, 120.9802729),
    "Price": 50,
  },
  {
    "Name": "Dominican",
    "LatLng": LatLng(14.1270838, 120.9737129),
    "Price": 60,
  },
  {
    "Name": "st. gabriel",
    "LatLng": LatLng(14.126487, 120.977440),
    "Price": 60,
  },
  {
    "Name": "mag-asawang ilat",
    "LatLng": LatLng(14.1293791, 120.9640769),
    "Price": 70,
  },
  {
    "Name": "San jose",
    "LatLng": LatLng(14.1213218, 120.9680338),
    "Price": 60,
  },
  {
    "Name": "olivarez",
    "LatLng": LatLng(14.1180630, 120.9613108),
    "Price": 70,
  },
  {
    "Name": "Fora",
    "LatLng": LatLng(14.1164853, 120.9611196),
    "Price": 70,
  },
  {
    "Name": "ayala",
    "LatLng": LatLng(14.1133006, 120.9595693),
    "Price": 70,
  },
];

const List<Map<String, dynamic>> ScienceCenterTerminalFare = [
  {
    "Name": "Mendoza st.",
    "LatLng": LatLng(14.1249650, 120.9948859),
    "Price": 40,
  },
  {
    "Name": "Picnic",
    "LatLng": LatLng(14.1259746, 120.9970865),
    "Price": 40,
  },
  {
    "Name": "Dap",
    "LatLng": LatLng(14.1257155, 120.9962186),
    "Price": 40,
  },
  {
    "Name": "Bliss",
    "LatLng": LatLng(14.1265249, 120.9976710),
    "Price": 40,
  },
  {
    "Name": "One Bagger",
    "LatLng": LatLng(14.1287917, 121.0006531),
    "Price": 50,
  },
  {
    "Name": "St. Michael",
    "LatLng": LatLng(14.1398640, 120.9907823),
    "Price": 60,
  },
  {
    "Name": "MaryRidge",
    "LatLng": LatLng(14.1290596, 121.0011482),
    "Price": 50,
  },
  {
    "Name": "Kapalaran",
    "LatLng": LatLng(14.1272725, 120.9990677),
    "Price": 50,
  },
  {
    "Name": "Able Site",
    "LatLng": LatLng(14.1295015, 121.0012876),
    "Price": 50,
  },
  {
    "Name": "Kay Payad",
    "LatLng": LatLng(14.1323104, 121.0064155),
    "Price": 50,
  },
  {
    "Name": " Kanto Kabangaan",
    "LatLng": LatLng(14.1318829, 121.0045964),
    "Price": 50,
  },
  {
    "Name": "Bulalong Matanda",
    "LatLng": LatLng(14.1460528, 121.0044399),
    "Price": 60,
  },
  {
    "Name": "Crosswinds",
    "LatLng": LatLng(14.1360794, 121.0111080),
    "Price": 60,
  },
  {
    "Name": "Bulalong Bata",
    "LatLng": LatLng(14.1382647, 120.9997006),
    "Price": 50,
  },
  {
    "Name": "Iruhin central",
    "LatLng": LatLng(14.1382023, 121.0156648),
    "Price": 70,
  },
  {
    "Name": "people\'s park",
    "LatLng": LatLng(14.1428315, 121.0225003),
    "Price": 80,
  },
  {
    "Name": "Dapdap west",
    "LatLng": LatLng(14.1513610, 121.0140288),
    "Price": 80,
  },
  {
    "Name": "Dapdap East",
    "LatLng": LatLng(14.1546009, 121.0276440),
    "Price": 100,
  },
  {
    "Name": "Calabuso",
    "LatLng": LatLng(14.1467864, 121.0287162),
    "Price": 80,
  },
  {
    "Name": "ligaya dive",
    "LatLng": LatLng(14.1233960, 120.9897068),
    "Price": 40,
  },
  {
    "Name": "Mariapolis",
    "LatLng": LatLng(14.1190577, 120.9879081),
    "Price": 40,
  },
  {
    "Name": "Catmon",
    "LatLng": LatLng(14.1185057, 120.9874246),
    "Price": 40,
  },
  {
    "Name": "Bagong Silang",
    "LatLng": LatLng(14.1198454, 120.9858005),
    "Price": 40,
  },
  {
    "Name": "Sta Monica",
    "LatLng": LatLng(14.1258559, 120.9842877),
    "Price": 40,
  },
  {
    "Name": "Francisco",
    "LatLng": LatLng(14.1369645, 120.9866239),
    "Price": 60,
  },
  {
    "Name": "Tolentino",
    "LatLng": LatLng(14.1275933, 120.9797253),
    "Price": 60,
  },
  {
    "Name": "Marasigan Lane",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 60,
  },
  {
    "Name": "city market",
    "LatLng": LatLng(14.1276363, 120.9802729),
    "Price": 50,
  },
  {
    "Name": "Dominican",
    "LatLng": LatLng(14.1270838, 120.9737129),
    "Price": 50,
  },
  {
    "Name": "st. gabriel",
    "LatLng": LatLng(14.126487, 120.977440),
    "Price": 50,
  },
  {
    "Name": "mag-asawang ilat",
    "LatLng": LatLng(14.1293791, 120.9640769),
    "Price": 70,
  },
  {
    "Name": "San jose",
    "LatLng": LatLng(14.1213218, 120.9680338),
    "Price": 60,
  },
  {
    "Name": "olivarez",
    "LatLng": LatLng(14.1180630, 120.9613108),
    "Price": 80,
  },
  {
    "Name": "Fora",
    "LatLng": LatLng(14.1164853, 120.9611196),
    "Price": 80,
  },
  {
    "Name": "ayala",
    "LatLng": LatLng(14.1133006, 120.9595693),
    "Price": 80,
  },
];

const List<Map<String, dynamic>> MariapolisTerminalFare = [
  {
    "Name": "Center",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 40,
  },
  {
    "Name": "Science",
    "LatLng": LatLng(14.1238453, 120.9922370),
    "Price": 40,
  },
  {
    "Name": "Central",
    "LatLng": LatLng(14.1236152, 120.9895251),
    "Price": 40,
  },
  {
    "Name": "Mendoza st.",
    "LatLng": LatLng(14.1249650, 120.9948859),
    "Price": 50,
  },
  {
    "Name": "Picnic",
    "LatLng": LatLng(14.1259746, 120.9970865),
    "Price": 50,
  },
  {
    "Name": "Dap",
    "LatLng": LatLng(14.1257155, 120.9962186),
    "Price": 50,
  },
  {
    "Name": "Bliss",
    "LatLng": LatLng(14.1265249, 120.9976710),
    "Price": 50,
  },
  {
    "Name": "One Bagger",
    "LatLng": LatLng(14.1287917, 121.0006531),
    "Price": 60,
  },
  {
    "Name": "St. Michael",
    "LatLng": LatLng(14.1398640, 120.9907823),
    "Price": 50,
  },
  {
    "Name": "MaryRidge",
    "LatLng": LatLng(14.1290596, 121.0011482),
    "Price": 60,
  },
  {
    "Name": "Kapalaran",
    "LatLng": LatLng(14.1272725, 120.9990677),
    "Price": 60,
  },
  {
    "Name": "Able Site",
    "LatLng": LatLng(14.1295015, 121.0012876),
    "Price": 60,
  },
  {
    "Name": "Kanto Kabangaan",
    "LatLng": LatLng(14.1318829, 121.0045964),
    "Price": 60,
  },
  {
    "Name": "Kay Payad",
    "LatLng": LatLng(14.1323104, 121.0064155),
    "Price": 70,
  },
  {
    "Name": "Bulalong Matanda",
    "LatLng": LatLng(14.1460528, 121.0044399),
    "Price": 70,
  },
  {
    "Name": "Crosswinds",
    "LatLng": LatLng(14.1360794, 121.0111080),
    "Price": 70,
  },
  {
    "Name": "Bulalong Bata",
    "LatLng": LatLng(14.1382647, 120.9997006),
    "Price": 60,
  },
  {
    "Name": "Iruhin central",
    "LatLng": LatLng(14.1382023, 121.0156648),
    "Price": 70,
  },
  {
    "Name": "people\'s park",
    "LatLng": LatLng(14.1428315, 121.0225003),
    "Price": 80,
  },
  {
    "Name": "Dapdap west",
    "LatLng": LatLng(14.1513610, 121.0140288),
    "Price": 80,
  },
  {
    "Name": "Dapdap East",
    "LatLng": LatLng(14.1546009, 121.0276440),
    "Price": 100,
  },
  {
    "Name": "Calabuso",
    "LatLng": LatLng(14.1467864, 121.0287162),
    "Price": 80,
  },
  {
    "Name": "SVD",
    "LatLng": LatLng(14.1275568, 120.9649262),
    "Price": 70,
  },
  {
    "Name": " Sta Monica",
    "LatLng": LatLng(14.1258559, 120.9842877),
    "Price": 40,
  },
  {
    "Name": "Marasigan Lane",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 40,
  },
  {
    "Name": "Francisco",
    "LatLng": LatLng(14.1369645, 120.9866239),
    "Price": 50,
  },
  {
    "Name": "Tolentino",
    "LatLng": LatLng(14.1275933, 120.9797253),
    "Price": 50,
  },
  {
    "Name": "city market",
    "LatLng": LatLng(14.1276363, 120.9802729),
    "Price": 50,
  },
  {
    "Name": "Dominican",
    "LatLng": LatLng(14.1270838, 120.9737129),
    "Price": 60,
  },
  {
    "Name": "st. gabriel",
    "LatLng": LatLng(14.126487, 120.977440),
    "Price": 60,
  },
  {
    "Name": "mag-asawang ilat",
    "LatLng": LatLng(14.1293791, 120.9640769),
    "Price": 70,
  },
  {
    "Name": "San jose",
    "LatLng": LatLng(14.1213218, 120.9680338),
    "Price": 70,
  },
  {
    "Name": "olivarez",
    "LatLng": LatLng(14.1180630, 120.9613108),
    "Price": 70,
  },
  {
    "Name": "Fora",
    "LatLng": LatLng(14.1164853, 120.9611196),
    "Price": 70,
  },
  {
    "Name": "ayala",
    "LatLng": LatLng(14.1133006, 120.9595693),
    "Price": 70,
  },
];

const List<Map<String, dynamic>> picnicTerminalFare = [
  {
    "Name": "Center",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 40,
  },
  {
    "Name": "Science",
    "LatLng": LatLng(14.1238453, 120.9922370),
    "Price": 40,
  },
  {
    "Name": "Central",
    "LatLng": LatLng(14.1236152, 120.9895251),
    "Price": 40,
  },
  {
    "Name": "ligaya dive",
    "LatLng": LatLng(14.1233960, 120.9897068),
    "Price": 40,
  },
  {
    "Name": "Mendoza st.",
    "LatLng": LatLng(14.1249650, 120.9948859),
    "Price": 40,
  },
  {
    "Name": "Dap",
    "LatLng": LatLng(14.1257155, 120.9962186),
    "Price": 40,
  },
  {
    "Name": "Bliss",
    "LatLng": LatLng(14.1265249, 120.9976710),
    "Price": 40,
  },
  {
    "Name": "One Bagger",
    "LatLng": LatLng(14.1287917, 121.0006531),
    "Price": 40,
  },
  {
    "Name": "St. Michael",
    "LatLng": LatLng(14.1398640, 120.9907823),
    "Price": 40,
  },
  {
    "Name": "MaryRidge",
    "LatLng": LatLng(14.1290596, 121.0011482),
    "Price": 40,
  },
  {
    "Name": "Kapalaran",
    "LatLng": LatLng(14.1272725, 120.9990677),
    "Price": 40,
  },
  {
    "Name": "Able Site",
    "LatLng": LatLng(14.1295015, 121.0012876),
    "Price": 40,
  },
  {
    "Name": "Kay Payad",
    "LatLng": LatLng(14.1323104, 121.0064155),
    "Price": 40,
  },
  {
    "Name": "Kanto Kabangaan",
    "LatLng": LatLng(14.1318829, 121.0045964),
    "Price": 40,
  },
  {
    "Name": "Bulalong Matanda",
    "LatLng": LatLng(14.1460528, 121.0044399),
    "Price": 50,
  },
  {
    "Name": "Crosswinds",
    "LatLng": LatLng(14.1360794, 121.0111080),
    "Price": 50,
  },
  {
    "Name": "Bulalong Bata",
    "LatLng": LatLng(14.1382647, 120.9997006),
    "Price": 40,
  },
  {
    "Name": "Iruhin central",
    "LatLng": LatLng(14.1382023, 121.0156648),
    "Price": 60,
  },
  {
    "Name": "people\'s park",
    "LatLng": LatLng(14.1428315, 121.0225003),
    "Price": 70,
  },
  {
    "Name": "Dapdap west",
    "LatLng": LatLng(14.1513610, 121.0140288),
    "Price": 70,
  },
  {
    "Name": "Dapdap East",
    "LatLng": LatLng(14.1546009, 121.0276440),
    "Price": 90,
  },
  {
    "Name": "Calabuso",
    "LatLng": LatLng(14.1467864, 121.0287162),
    "Price": 70,
  },
  {
    "Name": "ligaya dive",
    "LatLng": LatLng(14.1233960, 120.9897068),
    "Price": 40,
  },
  {
    "Name": "Mariapolis",
    "LatLng": LatLng(14.1190577, 120.9879081),
    "Price": 40,
  },
  {
    "Name": "Catmon",
    "LatLng": LatLng(14.1185057, 120.9874246),
    "Price": 40,
  },
  {
    "Name": "Bagong Silang",
    "LatLng": LatLng(14.1198454, 120.9858005),
    "Price": 40,
  },
  {
    "Name": "Sta Monica",
    "LatLng": LatLng(14.1258559, 120.9842877),
    "Price": 40,
  },
  {
    "Name": "Marasigan Lane",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 40,
  },
  {
    "Name": "Francisco",
    "LatLng": LatLng(14.1369645, 120.9866239),
    "Price": 70,
  },
  {
    "Name": "Tolentino",
    "LatLng": LatLng(14.1275933, 120.9797253),
    "Price": 70,
  },
  {
    "Name": "city market",
    "LatLng": LatLng(14.1276363, 120.9802729),
    "Price": 60,
  },
  {
    "Name": "Dominican",
    "LatLng": LatLng(14.1270838, 120.9737129),
    "Price": 50,
  },
  {
    "Name": "st. gabriel",
    "LatLng": LatLng(14.126487, 120.977440),
    "Price": 50,
  },
  {
    "Name": "mag-asawang ilat",
    "LatLng": LatLng(14.1293791, 120.9640769),
    "Price": 80,
  },
  {
    "Name": "San jose",
    "LatLng": LatLng(14.1213218, 120.9680338),
    "Price": 60,
  },
  {
    "Name": "olivarez",
    "LatLng": LatLng(14.1180630, 120.9613108),
    "Price": 80,
  },
  {
    "Name": "Fora",
    "LatLng": LatLng(14.1164853, 120.9611196),
    "Price": 80,
  },
  {
    "Name": "ayala",
    "LatLng": LatLng(14.1133006, 120.9595693),
    "Price": 80,
  },
];

const List<Map<String, dynamic>> stmichaelTerminalFare = [
  {
    "Name": "Anya Resort",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 60,
  },
  {
    "Name": "Center",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 50,
  },
  {
    "Name": "Science",
    "LatLng": LatLng(14.1238453, 120.9922370),
    "Price": 50,
  },
  {
    "Name": "Central",
    "LatLng": LatLng(14.1236152, 120.9895251),
    "Price": 50,
  },
  {
    "Name": "Mendoza st.",
    "LatLng": LatLng(14.1249650, 120.9948859),
    "Price": 50,
  },
  {
    "Name": "Picnic",
    "LatLng": LatLng(14.1259746, 120.9970865),
    "Price": 40,
  },
  {
    "Name": "Dap",
    "LatLng": LatLng(14.1257155, 120.9962186),
    "Price": 40,
  },
  {
    "Name": "Bliss",
    "LatLng": LatLng(14.1265249, 120.9976710),
    "Price": 50,
  },
  {
    "Name": "One Bagger",
    "LatLng": LatLng(14.1287917, 121.0006531),
    "Price": 50,
  },
  {
    "Name": "MaryRidge",
    "LatLng": LatLng(14.1290596, 121.0011482),
    "Price": 50,
  },
  {
    "Name": "Kapalaran",
    "LatLng": LatLng(14.1272725, 120.9990677),
    "Price": 50,
  },
  {
    "Name": "Able Site",
    "LatLng": LatLng(14.1295015, 121.0012876),
    "Price": 50,
  },
  {
    "Name": "Kay Payad",
    "LatLng": LatLng(14.1323104, 121.0064155),
    "Price": 60,
  },
  {
    "Name": "Kanto Kabangaan",
    "LatLng": LatLng(14.1318829, 121.0045964),
    "Price": 60,
  },
  {
    "Name": "Bulalong Matanda",
    "LatLng": LatLng(14.1460528, 121.0044399),
    "Price": 70,
  },
  {
    "Name": "Crosswinds",
    "LatLng": LatLng(14.1360794, 121.0111080),
    "Price": 70,
  },
  {
    "Name": "Bulalong Bata",
    "LatLng": LatLng(14.1382647, 120.9997006),
    "Price": 60,
  },
  {
    "Name": "Iruhin central",
    "LatLng": LatLng(14.1382023, 121.0156648),
    "Price": 70,
  },
  {
    "Name": "people\'s park",
    "LatLng": LatLng(14.1428315, 121.0225003),
    "Price": 80,
  },
  {
    "Name": "Dapdap west",
    "LatLng": LatLng(14.1513610, 121.0140288),
    "Price": 80,
  },
  {
    "Name": "Dapdap East",
    "LatLng": LatLng(14.1546009, 121.0276440),
    "Price": 100,
  },
  {
    "Name": "Calabuso",
    "LatLng": LatLng(14.1467864, 121.0287162),
    "Price": 80,
  },
  {
    "Name": "Mariapolis",
    "LatLng": LatLng(14.1190577, 120.9879081),
    "Price": 50,
  },
  {
    "Name": "ligaya dive",
    "LatLng": LatLng(14.1233960, 120.9897068),
    "Price": 50,
  },
  {
    "Name": "Catmon",
    "LatLng": LatLng(14.1185057, 120.9874246),
    "Price": 50,
  },
  {
    "Name": "Bagong Silang",
    "LatLng": LatLng(14.1198454, 120.9858005),
    "Price": 50,
  },
  {
    "Name": "south ridge",
    "LatLng": LatLng(14.1238166, 120.9913537),
    "Price": 50,
  },
  {
    "Name": "Central",
    "LatLng": LatLng(14.1236152, 120.9895251),
    "Price": 50,
  },
  {
    "Name": "Sta Monica",
    "LatLng": LatLng(14.1258559, 120.9842877),
    "Price": 60,
  },
  {
    "Name": "Marasigan Lane",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 60,
  },
  {
    "Name": "Francisco",
    "LatLng": LatLng(14.1369645, 120.9866239),
    "Price": 50,
  },
  {
    "Name": "Tolentino",
    "LatLng": LatLng(14.1275933, 120.9797253),
    "Price": 50,
  },
  {
    "Name": "Dominican",
    "LatLng": LatLng(14.1270838, 120.9737129),
    "Price": 60,
  },
  {
    "Name": "city market",
    "LatLng": LatLng(14.1276363, 120.9802729),
    "Price": 50,
  },
  {
    "Name": "st. gabriel",
    "LatLng": LatLng(14.126487, 120.977440),
    "Price": 60,
  },
  {
    "Name": "mag-asawang ilat",
    "LatLng": LatLng(14.1293791, 120.9640769),
    "Price": 80,
  },
  {
    "Name": "SVD",
    "LatLng": LatLng(14.1275568, 120.9649262),
    "Price": 80,
  },
  {
    "Name": "pink sister",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 70,
  },
  {
    "Name": "vilbay st",
    "LatLng": LatLng(14.1271764, 120.9582405),
    "Price": 70,
  },
  {
    "Name": "San jose",
    "LatLng": LatLng(14.1213218, 120.9680338),
    "Price": 70,
  },
  {
    "Name": "olivarez",
    "LatLng": LatLng(14.1180630, 120.9613108),
    "Price": 80,
  },
  {
    "Name": "Fora",
    "LatLng": LatLng(14.1164853, 120.9611196),
    "Price": 80,
  },
  {
    "Name": "ayala",
    "LatLng": LatLng(14.1133006, 120.9595693),
    "Price": 80,
  },
];

const List<Map<String, dynamic>> peoplesParkTerminalFare = [
  {
    "Name": "Center",
    "LatLng": LatLng(14.1238232, 120.9917878),
    "Price": 70,
  },
  {
    "Name": "Science",
    "LatLng": LatLng(14.1238453, 120.9922370),
    "Price": 70,
  },
  {
    "Name": "Central",
    "LatLng": LatLng(14.1236152, 120.9895251),
    "Price": 70,
  },
  {
    "Name": "ligaya dive",
    "LatLng": LatLng(14.1233960, 120.9897068),
    "Price": 80,
  },
  {
    "Name": "Mendoza st.",
    "LatLng": LatLng(14.1249650, 120.9948859),
    "Price": 70,
  },
  {
    "Name": "Dap",
    "LatLng": LatLng(14.1257155, 120.9962186),
    "Price": 60,
  },
  {
    "Name": "Bliss",
    "LatLng": LatLng(14.1265249, 120.9976710),
    "Price": 60,
  },
  {
    "Name": "One Bagger",
    "LatLng": LatLng(14.1287917, 121.0006531),
    "Price": 60,
  },
  {
    "Name": "St. Michael",
    "LatLng": LatLng(14.1398640, 120.9907823),
    "Price": 70,
  },
  {
    "Name": "MaryRidge",
    "LatLng": LatLng(14.1290596, 121.0011482),
    "Price": 60,
  },
  {
    "Name": "Kapalaran",
    "LatLng": LatLng(14.1272725, 120.9990677),
    "Price": 60,
  },
  {
    "Name": "Able Site",
    "LatLng": LatLng(14.1295015, 121.0012876),
    "Price": 60,
  },
  {
    "Name": "Kay Payad",
    "LatLng": LatLng(14.1323104, 121.0064155),
    "Price": 60,
  },
  {
    "Name": "Kanto Kabangaan",
    "LatLng": LatLng(14.1318829, 121.0045964),
    "Price": 60,
  },
  {
    "Name": "Bulalong Matanda",
    "LatLng": LatLng(14.1460528, 121.0044399),
    "Price": 50,
  },
  {
    "Name": "Crosswinds",
    "LatLng": LatLng(14.1360794, 121.0111080),
    "Price": 50,
  },
  {
    "Name": "Bulalong Bata",
    "LatLng": LatLng(14.1382647, 120.9997006),
    "Price": 60,
  },
  {
    "Name": "Iruhin central",
    "LatLng": LatLng(14.1382023, 121.0156648),
    "Price": 50,
  },
  {
    "Name": "people's park",
    "LatLng": LatLng(14.1428315, 121.0225003),
    "Price": 70,
  },
  {
    "Name": "Dapdap East",
    "LatLng": LatLng(14.1546009, 121.0276440),
    "Price": 50,
  },
  {
    "Name": "Calabuso",
    "LatLng": LatLng(14.1467864, 121.0287162),
    "Price": 50,
  },
  {
    "Name": "Mariapolis",
    "LatLng": LatLng(14.1190577, 120.9879081),
    "Price": 80,
  },
  {
    "Name": "Catmon",
    "LatLng": LatLng(14.1185057, 120.9874246),
    "Price": 80,
  },
  {
    "Name": "Bagong Silang",
    "LatLng": LatLng(14.1198454, 120.9858005),
    "Price": 80,
  },
  {
    "Name": "Sta Monica",
    "LatLng": LatLng(14.1258559, 120.9842877),
    "Price": 70,
  },
  {
    "Name": "Marasigan Lane",
    "LatLng": LatLng(14.1240714, 120.9829730),
    "Price": 70,
  },
  {
    "Name": "Francisco",
    "LatLng": LatLng(14.1369645, 120.9866239),
    "Price": 80,
  },
  {
    "Name": "Tolentino",
    "LatLng": LatLng(14.1275933, 120.9797253),
    "Price": 80,
  },
  {
    "Name": "city market",
    "LatLng": LatLng(14.1276363, 120.9802729),
    "Price": 80,
  },
  {
    "Name": "Dominican",
    "LatLng": LatLng(14.1270838, 120.9737129),
    "Price": 120,
  },
  {
    "Name": "st. gabriel",
    "LatLng": LatLng(14.126487, 120.977440),
    "Price": 120,
  },
  {
    "Name": "mag-asawang ilat",
    "LatLng": LatLng(14.1293791, 120.9640769),
    "Price": 120,
  },
  {
    "Name": "San jose",
    "LatLng": LatLng(14.1213218, 120.9680338),
    "Price": 120,
  },
  {
    "Name": "olivarez",
    "LatLng": LatLng(14.1180630, 120.9613108),
    "Price": 150,
  },
  {
    "Name": "Fora",
    "LatLng": LatLng(14.1164853, 120.9611196),
    "Price": 150,
  },
  {
    "Name": "ayala",
    "LatLng": LatLng(14.1133006, 120.9595693),
    "Price": 150,
  },
];

const List<Map<String, dynamic>> zone4FareKantoSvd = [
  {
    "Name": 'San Jose',
    "LatLng": LatLng(14.1148795, 120.9673516),
    "Price": 40,
  },
  {
    "Name": 'SilangCrossingEast',
    "LatLng": LatLng(14.1074510, 120.9594144),
    "Price": 40,
  },
  {
    "Name": 'MagAsawangIlat',
    "LatLng": LatLng(14.1327510, 120.9669259),
    "Price": 50,
  },
  {
    "Name": 'Maitim 2nd East',
    "LatLng": LatLng(14.1286220, 120.9587870),
    "Price": 40,
  },
  {
    "Name": 'Maitim 2nd Central',
    "LatLng": LatLng(14.1236951, 120.9505355),
    "Price": 50,
  },
  {
    "Name": 'Maitim 2nd West',
    "LatLng": LatLng(14.1216455, 120.9447945),
    "Price": 70,
  },
];

const List<Map<String, dynamic>> zone4FareOlivaresPlaza = [
  {
    "Name": 'SanJose',
    "LatLng": LatLng(14.1148795, 120.9673516),
    "Price": 40,
  },
  {
    "Name": ' SilangCrossingEast',
    "LatLng": LatLng(14.1074510, 120.9594144),
    "Price": 40,
  },
  {
    "Name": 'MagAsawangIlat',
    "LatLng": LatLng(14.1327510, 120.9669259),
    "Price": 50,
  },
  {
    "Name": 'Maitim 2nd East',
    "LatLng": LatLng(14.1286220, 120.9587870),
    "Price": 40,
  },
  {
    "Name": 'Maitim 2nd Central',
    "LatLng": LatLng(14.1236951, 120.9505355),
    "Price": 60,
  },
  {
    "Name": 'Maitim 2nd West',
    "LatLng": LatLng(14.1216455, 120.9447945),
    "Price": 80,
  },
];

const List<Map<String, dynamic>> zone4FareKantoTCI = [
  {
    "Name": "Maitim 1st Elementary School",
    "LatLng": LatLng(14.1416703, 120.9479222),
    "Price": 40,
  },
  {
    "Name": "Maitim 1st Barangay Hall",
    "LatLng": LatLng(14.14023096536415, 120.94933981095792),
    "Price": 40,
  },
  {
    "Name": "Pious Heights",
    "LatLng": LatLng(14.129567654332199, 120.95302912023011),
    "Price": 40,
  },
  {
    "Name": "Tibayan Street",
    "LatLng": LatLng(14.127021556196473, 120.95530389561218),
    "Price": 40,
  },
  {
    "Name": "Vilbay Street",
    "LatLng": LatLng(14.127220329885324, 120.95796330910318),
    "Price": 40,
  },
  {
    "Name": "Church of Christ",
    "LatLng": LatLng(14.138157042903789, 120.94029141577643),
    "Price": 40,
  },
  {
    "Name": "Potter Noster",
    "LatLng": LatLng(14.126194745004364, 120.95062264016899),
    "Price": 40,
  },
  {
    "Name": "Prime Peak",
    "LatLng": LatLng(14.119528452254345, 120.94877432444844),
    "Price": 40,
  },
  {
    "Name": "Tviand Specials",
    "LatLng": LatLng(14.125941556987126, 120.939755453285),
    "Price": 40,
  },
  {
    "Name": "Servico By Pass Road",
    "LatLng": LatLng(14.126996179871883, 120.9444266276858),
    "Price": 60,
  },
  {
    "Name": "MetroGate Tagaytay Manors",
    "LatLng": LatLng(14.12443386258079, 120.94754594535748),
    "Price": 40,
  },
  {
    "Name": "Chateau Trouvaille Resort & Event Place",
    "LatLng": LatLng(114.124965753236301, 120.94559039324811),
    "Price": 40,
  },
  {
    "Name": "Wingate Manors",
    "LatLng": LatLng(14.118981162081504, 120.9450014956123),
    "Price": 50,
  },
  {
    "Name": "Alta Monte",
    "LatLng": LatLng(14.118981162081504, 120.9450014956123),
    "Price": 55,
  },
  {
    "Name": "Wingate Manors",
    "LatLng": LatLng(14.118981162081504, 120.9450014956123),
    "Price": 50,
  },
  {
    "Name": "Tagaste",
    "LatLng": LatLng(14.118981162081504, 120.9450014956123),
    "Price": 65,
  },
  {
    "Name": "Pacific Grove",
    "LatLng": LatLng(14.113625680951868, 120.94730213979373),
    "Price": 65,
  },
  {
    "Name": "Nurture",
    "LatLng": LatLng(14.125283350132111, 120.94191971714034),
    "Price": 40,
  },
  {
    "Name": "Boundary Maitim-Talon",
    "LatLng": LatLng(14.13834812526039, 120.94012134194466),
    "Price": 50,
  },
  {
    "Name": "Pamayanan Iglesia Ni Cristo",
    "LatLng": LatLng(14.110105986282013, 120.95009904539458),
    "Price": 75,
  },
  {
    "Name": "Kingdom Hall",
    "LatLng": LatLng(14.108063332943733, 120.94971653472864),
    "Price": 80,
  },
  {
    "Name": "Magallenes Square",
    "LatLng": LatLng(14.103535511496775, 120.95117185328459),
    "Price": 90,
  },
  {
    "Name": "Sta.Rita",
    "LatLng": LatLng(14.113177748354726, 120.94280842888358),
    "Price": 90,
  },
];

List<TariffsClass> convertFareListToTariff(
    List<Map<String, dynamic>> values, String zone, String terminalName) {
  return values.map((map) {
    return TariffsClass(
      placeName: map['Name'],
      locationLatLng: map['LatLng'],
      price: map['Price'],
      zone: zone,
      terminalName: terminalName,
    );
  }).toList();
}

List<List<TariffsClass>> tariffsList = [
  convertFareListToTariff(
      zone1AMahoganyTerminalFare, 'Zone 1-A', terminal1Zone1A),
  convertFareListToTariff(
      zone1AMahoganyTerminalFare, 'Zone 1-A', dummyTerminalZone1A),
  convertFareListToTariff(
      zone1AMahoganyTerminalFare, 'Zone 1-A', 'EVAL HOJ DUMMY TERMINAL'),
  convertFareListToTariff(
      zone1BRadarTaasTerminalFare, 'Zone 1-B', terminal1Zone1B),
  convertFareListToTariff(
      zone1BTerminalBabaTerminalFare, 'Zone 1-B', terminal2Zone1B),
  convertFareListToTariff(
      zone1CPatutoTerminalFare, 'Zone 1-C', terminal1Zone1C),
  convertFareListToTariff(
      zone1DKantoMaterDeiTerminalFare, 'Zone 1-D', terminal1Zone1D),
  convertFareListToTariff(
      zone2AMagallanesTerminalFare, 'Zone 2-A', terminal1Zone2A),
  convertFareListToTariff(
      zone2ATagasteTerminalFare, 'Zone 2-A', terminal2Zone2A),
  convertFareListToTariff(
      zone2KantoNBITerminalFare, 'Zone 2-A', terminal1Zone2),
  convertFareListToTariff(ayalaTerminalFare, 'Zone 3', terminal1Zone3),
  convertFareListToTariff(olivarezTerminalFare, 'Zone 3', terminal2Zone3),
  convertFareListToTariff(foraTerminalFare, 'Zone 3', terminal3Zone3),
  convertFareListToTariff(
      grandTerminalMarketTerminalFare, 'Zone 3', terminal4Zone3),
  convertFareListToTariff(dominicanTerminalFare, 'Zone 3', terminal5Zone3),
  convertFareListToTariff(wetMarketTerminalFare, 'Zone 3', terminal6Zone3),
  convertFareListToTariff(tolentinoTerminalFare, 'Zone 3', terminal7Zone3),
  convertFareListToTariff(olivarezTerminalFare, 'Zone 3', 'DUMMY TERMINAL'),
  convertFareListToTariff(
      tolentinoTerminalFare, 'Zone 3', 'EVAL DUMMY TERMINAL'),
  convertFareListToTariff(citymarketTerminalFare, 'Zone 3', terminal8Zone3),
  convertFareListToTariff(peoplesParkTerminalFare, 'Zone 3-A', terminal1Zone3A),
  convertFareListToTariff(stmichaelTerminalFare, 'Zone 3-A', terminal2Zone3A),
  convertFareListToTariff(picnicTerminalFare, 'Zone 3-A', terminal3Zone3A),
  convertFareListToTariff(
      ScienceCenterTerminalFare, 'Zone 3-A', terminal4Zone3A),
  convertFareListToTariff(LigayaDriveTerminalFare, 'Zone 3-A', terminal5Zone3A),
  convertFareListToTariff(
      ScienceCenterTerminalFare, 'Zone 3-A', terminal6Zone3A),
  convertFareListToTariff(MariapolisTerminalFare, 'Zone 3-A', terminal7Zone3A),
  convertFareListToTariff(zone4FareOlivaresPlaza, 'Zone 4', terminal2Zone4),
  convertFareListToTariff(zone4FareKantoSvd, 'Zone 4', terminal3Zone4),
  convertFareListToTariff(zone4FareKantoTCI, 'Zone 4-A', terminal1Zone4A),
];
