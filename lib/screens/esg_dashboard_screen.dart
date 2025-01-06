import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/esg_service.dart';
import '../models/esg_data_point.dart';

class ESGDashboardScreen extends StatefulWidget {
  const ESGDashboardScreen({super.key});

  @override
  _ESGDashboardScreenState createState() => _ESGDashboardScreenState();
}

class _ESGDashboardScreenState extends State<ESGDashboardScreen> {
  final ESGService _esgService = ESGService();
  Map<String, List<ESGDataPoint>>? _esgData;
  List<ESGIndicator> _indicators = [];
  bool _isLoading = false;
  String _selectedCountry = 'USA';
  bool _dataVisible = false; // New state flag

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
          _dataVisible = true; // Show data after load
        });
      } else {
        print('No indicators available');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error in ESG Dashboard: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load ESG data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESG Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : AnimatedOpacity(
              opacity: _dataVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: _esgData == null || _esgData!.isEmpty
                  ? const Center(child: Text('No data available'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildCountrySelector(),
                          const SizedBox(height: 24), // Increased spacing
                          ..._buildIndicatorCards(),
                        ],
                      ),
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
        margin: const EdgeInsets.only(bottom: 24), // Increased spacing
        child: Padding(
          padding: const EdgeInsets.all(24), // Increased padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                indicator.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8), // Added spacing
              Text(
                indicator.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16), // Increased spacing
              SizedBox(
                height: 250, // Increased height
                child: data.isEmpty
                    ? const Center(child: Text('No data available'))
                    : _buildChart(data),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildChart(List<ESGDataPoint> data) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final spots = data
        .where((point) => point.value != null)
        .map((p) => FlSpot(
              double.parse(p.year.toString()),
              p.value!,
            ))
        .toList();

    return LineChart(
      LineChartData(
        lineTouchData: const LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            // ...existing tooltip config...
          ),
        ),
        minX: spots.first.x,
        maxX: spots.last.x,
        // ...existing axis titles/ticks...
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true, // increases line fluidity
            color: Colors.green,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.2),
            ),
          ),
        ],
        // ...additional spacing & grid config...
      ),
    );
  }
}