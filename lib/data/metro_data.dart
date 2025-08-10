import 'package:flutter/material.dart';
import '../models/metro_station.dart';

class MetroData {
  static const List<MetroLine> lines = [
    MetroLine(
      id: 'green',
      name: 'Green Line',
      color: Colors.green,
      isOperational: true,
      stations: [
        'madivara', 'chikkabanavara', 'manjunathanagar', 'nagasandra',
        'dasarahalli', 'jalahalli', 'peenya_industry', 'peenya',
        'goraguntepalya', 'yeshwantpur', 'sandal_soap_factory',
        'mahalakshmi', 'rajajinagar', 'kuvempu_road', 'srirampura',
        'sampige_road', 'majestic', 'city_railway_station', 'chickpet',
        'kr_market', 'national_college', 'lalbagh', 'south_end_circle',
        'jayanagar', 'rashtreeya_vidyalaya_road', 'banashankari',
        'jayaprakash_nagar', 'yelachenahalli', 'konanakunte_cross',
        'doddakallasandra', 'vajarahalli', 'thalaghattapura', 'silk_institute'
      ],
    ),
    MetroLine(
      id: 'purple',
      name: 'Purple Line',
      color: Colors.purple,
      isOperational: true,
      stations: [
        'challaghatta', 'kengeri', 'kengeri_bus_terminal', 'pattanagere',
        'jnanabharathi', 'rajarajeshwari_nagar', 'nayandahalli',
        'mysore_road', 'deepanjali_nagar', 'attiguppe', 'vijayanagar',
        'hosahalli', 'magadi_road', 'majestic', 'ksr_city_railway_station',
        'mahatma_gandhi_road', 'cubbon_park', 'vidhana_soudha',
        'sir_m_visvesvaraya_station_central_college', 'kempegowda_majestic',
        'chickpet', 'kr_market', 'national_college', 'lalbagh',
        'south_end_circle', 'jayanagar', 'rashtreeya_vidyalaya_road'
      ],
    ),
    MetroLine(
      id: 'yellow',
      name: 'Yellow Line',
      color: Colors.yellow,
      isOperational: true,
      stations: [
        'rashtreeya_vidyalaya_road', 'jayadeva_hospital', 'btm_layout',
        'silk_board', 'central_silk_board', 'hsr_layout', 'agara_lake',
        'bommanahalli', 'hongasandra', 'kudlu_gate', 'singasandra',
        'hebbagodi', 'electronic_city'
      ],
    ),
  ];

  static final List<MetroStation> stations = [
    // Green Line Stations
    const MetroStation(
      id: 'madivara',
      name: 'Madivara',
      latitude: 13.1373,
      longitude: 77.5016,
      lines: ['green'],
    ),
    // ... (I'll add key stations for the demo)
    const MetroStation(
      id: 'majestic',
      name: 'Kempegowda Bus Station (Majestic)',
      latitude: 12.9767,
      longitude: 77.5733,
      lines: ['green', 'purple'],
      isInterchange: true,
    ),
    const MetroStation(
      id: 'rashtreeya_vidyalaya_road',
      name: 'Rashtreeya Vidyalaya Road',
      latitude: 12.9298,
      longitude: 77.5685,
      lines: ['green', 'purple', 'yellow'],
      isInterchange: true,
    ),
    const MetroStation(
      id: 'lalbagh',
      name: 'Lalbagh',
      latitude: 12.9507,
      longitude: 77.5848,
      lines: ['green'],
    ),
    const MetroStation(
      id: 'electronic_city',
      name: 'Electronic City',
      latitude: 12.8440,
      longitude: 77.6630,
      lines: ['yellow'],
    ),
    const MetroStation(
      id: 'silk_board',
      name: 'Silk Board',
      latitude: 12.9177,
      longitude: 77.6226,
      lines: ['yellow'],
    ),
  ];
}