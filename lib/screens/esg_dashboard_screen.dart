import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/esg_service.dart';
import '../models/esg_data_point.dart';

class ESGDashboardScreen extends StatefulWidget {
  @override
  _ESGDashboardScreenState createState() => _ESGDashboardScreenState();
}

class _ESGDashboardScreenState extends State<ESGDashboardScreen> {
  final ESGService _esgService = ESGService();
  Map<String, List<ESGDataPoint>>? _esgData;
  List<ESGIndicator> _indicators = [];
  bool _isLoading = false;
  String _selectedCountry = 'USA';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() => _isLoading = true);

    try {
      // First fetch available indicators
      _indicators = await _esgService.fetchAvailableIndicators();
      
      if (_indicators.isNotEmpty) {
        // Then fetch data for all indicators
        final data = await _esgService.fetchDataForAllIndicators(
          countryCode: _selectedCountry,
          startYear: 2010,
          endYear: 2019,
        );

        setState(() {
          _esgData = data;
          _isLoading = false;
        });
      } else {
        print('No indicators available');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error in ESG Dashboard: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load ESG data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ESG Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _initializeData,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _esgData == null || _esgData!.isEmpty
              ? Center(child: Text('No data available'))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildCountrySelector(),
                      SizedBox(height: 16),
                      ..._buildIndicatorCards(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildCountrySelector() {
    return DropdownButton<String>(
      value: _selectedCountry,
      items: ['USA', 'GBR', 'DEU', 'FRA', 'JPN', 'CHN', 'IND']
          .map((code) => DropdownMenuItem(
                value: code,
                child: Text(code),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null && value != _selectedCountry) {
          setState(() => _selectedCountry = value);
          _initializeData();
        }
      },
    );
  }

  List<Widget> _buildIndicatorCards() {
    return _indicators.map((indicator) {
      final data = _esgData?[indicator.id] ?? [];

      return Card(
        margin: EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                indicator.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                indicator.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: data.isEmpty
                    ? Center(child: Text('No data available'))
                    : _buildChart(data),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildChart(List<ESGDataPoint> data) {
    final spots = data
        .where((point) => point.value != null && point.value! > 0)
        .map((point) => FlSpot(
              double.parse(point.year),
              point.value!,
            ))
        .toList();

    if (spots.isEmpty) {
      return Center(child: Text('No valid data points'));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}