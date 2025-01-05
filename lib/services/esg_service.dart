import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' show min;
import '../models/esg_data_point.dart';

class ESGIndicator {
  final String id;
  final String name;
  final String description;

  ESGIndicator({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  String toString() {
    return 'ESGIndicator(id: $id, name: $name)';
  }
}

class ESGService {
  static const String baseUrl = 'https://api.worldbank.org/v2';
  List<ESGIndicator> _availableIndicators = [];

  static final List<String> desiredIndicators = [
    'CO2',
    'emissions',
    'pollution',
    'energy'
  ];

  Future<List<ESGIndicator>> fetchAvailableIndicators() async {
    try {
      final url = '$baseUrl/indicators?format=json&per_page=500';
      print('Fetching indicators from: $url');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        if (decodedResponse is List &&
            decodedResponse.length >= 2 &&
            decodedResponse[1] != null) {
          final indicatorsList = decodedResponse[1] as List;
          _availableIndicators = indicatorsList.map((indicator) {
            return ESGIndicator(
              id: indicator['id'] ?? '',
              name: indicator['name'] ?? '',
              description: indicator['sourceNote'] ?? '',
            );
          }).where((indicator) {
            // Filter indicators related to our desired metrics
            return desiredIndicators.any((term) =>
                indicator.name.toLowerCase().contains(term.toLowerCase()) ||
                indicator.description
                    .toLowerCase()
                    .contains(term.toLowerCase()));
          }).toList();

          print('Found ${_availableIndicators.length} relevant indicators');
          _availableIndicators
              .forEach((ind) => print('Indicator: ${ind.toString()}'));

          return _availableIndicators;
        }
      }

      print('Failed to fetch indicators: ${response.statusCode}');
      return [];
    } catch (e, stackTrace) {
      print('Error fetching indicators: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchESGData({
    required String countryCode,
    required String indicator,
    int? startYear,
    int? endYear,
  }) async {
    try {
      final actualStartYear = startYear ?? 2010;
      final actualEndYear = endYear ?? 2019;

      final String dateParam = '&date=$actualStartYear:$actualEndYear';
      final url =
          '$baseUrl/country/$countryCode/indicator/$indicator?format=json&per_page=100$dateParam';

      print('Fetching ESG data from: $url');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        if (decodedResponse is List && decodedResponse.length >= 2) {
          final data = decodedResponse[1];
          print(
              'Successfully retrieved ${data.length} data points for $indicator');
          return {'data': data};
        }

        print('Unexpected response structure: $decodedResponse');
        return {'data': []};
      } else {
        print(
            'HTTP Error ${response.statusCode} for $indicator: ${response.body}');
        return {'data': []};
      }
    } catch (e, stackTrace) {
      print('Error fetching $indicator: $e');
      print('Stack trace: $stackTrace');
      return {'data': []};
    }
  }

  Future<Map<String, List<ESGDataPoint>>> fetchDataForAllIndicators({
    required String countryCode,
    int? startYear,
    int? endYear,
  }) async {
    if (_availableIndicators.isEmpty) {
      await fetchAvailableIndicators();
    }

    Map<String, List<ESGDataPoint>> results = {};

    for (var indicator in _availableIndicators) {
      try {
        print('\nFetching data for ${indicator.name} (${indicator.id})');
        final data = await fetchESGData(
          countryCode: countryCode,
          indicator: indicator.id,
          startYear: startYear,
          endYear: endYear,
        );

        final parsedData = parseESGData(data['data'] ?? [], indicator);
        print('Parsed ${parsedData.length} points for ${indicator.name}');

        if (parsedData.isNotEmpty) {
          results[indicator.id] = parsedData;
          print('Added data for ${indicator.name}');
        }
      } catch (e) {
        print('Error fetching indicator ${indicator.id}: $e');
        continue;
      }
    }

    return results;
  }

  List<ESGDataPoint> parseESGData(
      List<dynamic> rawData, ESGIndicator indicator) {
    final List<ESGDataPoint> dataPoints = [];

    for (var data in rawData) {
      try {
        final yearStr = data['date']?.toString() ?? '';
        final rawValue = data['value'];

        double? value;
        if (rawValue != null) {
          if (rawValue is num) {
            value = rawValue.toDouble();
          } else if (rawValue is String && rawValue.isNotEmpty) {
            value = double.tryParse(rawValue);
          }
        }

        if (value != null && yearStr.isNotEmpty) {
          dataPoints.add(ESGDataPoint(
            year: yearStr,
            value: value,
            indicatorId: indicator.id,
            indicatorName: indicator.name,
          ));
        }
      } catch (e) {
        print('Error parsing data point: $e');
        continue;
      }
    }

    return dataPoints..sort((a, b) => a.year.compareTo(b.year));
  }
}
