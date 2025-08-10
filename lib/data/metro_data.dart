import 'package:flutter/material.dart';
import '../models/metro_station.dart';

class MetroData {
  static final List<MetroLine> lines = [
    MetroLine(
      id: 'green',
      name: 'Green Line',
      color: Colors.green,
      isOperational: true,
      stations: const [
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
      stations: const [
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
      stations: const [
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
    const MetroStation(
      id: 'nagasandra',
      name: 'Nagasandra',
      latitude: 13.0988,
      longitude: 77.5512,
      lines: ['green'],
    ),
    const MetroStation(
      id: 'peenya_industry',
      name: 'Peenya Industry',
      latitude: 13.0280,
      longitude: 77.5186,
      lines: ['green'],
    ),
    const MetroStation(
      id: 'yeshwantpur',
      name: 'Yeshwantpur',
      latitude: 13.0223,
      longitude: 77.5540,
      lines: ['green'],
    ),
    const MetroStation(
      id: 'majestic',
      name: 'Kempegowda Bus Station (Majestic)',
      latitude: 12.9767,
      longitude: 77.5733,
      lines: ['green', 'purple'],
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
      id: 'south_end_circle',
      name: 'South End Circle',
      latitude: 12.9342,
      longitude: 77.5934,
      lines: ['green'],
    ),
    const MetroStation(
      id: 'jayanagar',
      name: 'Jayanagar',
      latitude: 12.9237,
      longitude: 77.5838,
      lines: ['green'],
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
      id: 'banashankari',
      name: 'Banashankari',
      latitude: 12.9081,
      longitude: 77.5753,
      lines: ['green'],
    ),
    const MetroStation(
      id: 'silk_institute',
      name: 'Silk Institute',
      latitude: 12.8472,
      longitude: 77.6380,
      lines: ['green'],
    ),
    
    // Purple Line Stations
    const MetroStation(
      id: 'challaghatta',
      name: 'Challaghatta',
      latitude: 12.8698,
      longitude: 77.4998,
      lines: ['purple'],
    ),
    const MetroStation(
      id: 'kengeri',
      name: 'Kengeri',
      latitude: 12.9077,
      longitude: 77.4851,
      lines: ['purple'],
    ),
    const MetroStation(
      id: 'nayandahalli',
      name: 'Nayandahalli',
      latitude: 12.9342,
      longitude: 77.5134,
      lines: ['purple'],
    ),
    const MetroStation(
      id: 'vijayanagar',
      name: 'Vijayanagar',
      latitude: 12.9629,
      longitude: 77.5311,
      lines: ['purple'],
    ),
    const MetroStation(
      id: 'cubbon_park',
      name: 'Cubbon Park',
      latitude: 12.9762,
      longitude: 77.5993,
      lines: ['purple'],
    ),
    
    // Yellow Line Stations
    const MetroStation(
      id: 'jayadeva_hospital',
      name: 'Jayadeva Hospital',
      latitude: 12.9189,
      longitude: 77.5821,
      lines: ['yellow'],
    ),
    const MetroStation(
      id: 'btm_layout',
      name: 'BTM Layout',
      latitude: 12.9165,
      longitude: 77.6101,
      lines: ['yellow'],
    ),
    const MetroStation(
      id: 'silk_board',
      name: 'Silk Board',
      latitude: 12.9177,
      longitude: 77.6226,
      lines: ['yellow'],
    ),
    const MetroStation(
      id: 'hsr_layout',
      name: 'HSR Layout',
      latitude: 12.9081,
      longitude: 77.6476,
      lines: ['yellow'],
    ),
    const MetroStation(
      id: 'electronic_city',
      name: 'Electronic City',
      latitude: 12.8440,
      longitude: 77.6630,
      lines: ['yellow'],
    ),
  ];
}