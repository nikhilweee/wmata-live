import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wmatalive/env/env.dart';
import 'package:wmatalive/models.dart';
import 'package:intl/intl.dart';

class WmataApi {
  final String baseUrl;
  final String apiKey;

  WmataApi({String? baseUrl, String? apiKey})
    : baseUrl = baseUrl ?? 'https://api.wmata.com',
      apiKey = apiKey ?? Env.wmataApiKey;

  // Get nearby stops given latitude and longitude
  Future<List<BusStop>> getNearbyStops(
    double lat,
    double lng, {
    int? radius,
  }) async {
    final effectiveRadius = radius ?? 500;
    final uri = Uri.parse(baseUrl);
    final url = Uri(
      scheme: uri.scheme,
      host: uri.host,
      path: '/Bus.svc/json/jStops',
      queryParameters: {
        'Lat': lat.toString(),
        'Lon': lng.toString(),
        'Radius': effectiveRadius.toString(),
      },
    );
    final response = await http.get(url, headers: {'api_key': apiKey});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final stops = data['Stops'] as List?;
      if (stops == null) return [];
      return stops.map((json) => BusStop.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load nearby stops');
    }
  }

  // Get stop schedule for a stop id and date
  Future<List<StopSchedule>> getStopSchedule(
    String stopId, {
    DateTime? date,
  }) async {
    final effectiveDate = date ?? DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd').format(effectiveDate);
    final uri = Uri.parse(baseUrl);
    final url = Uri(
      scheme: uri.scheme,
      host: uri.host,
      path: '/Bus.svc/json/jStopSchedule',
      queryParameters: {'StopID': stopId, 'Date': dateStr},
    );
    final response = await http.get(url, headers: {'api_key': apiKey});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final arrivals = data['ScheduleArrivals'] as List?;
      if (arrivals == null) return [];
      return arrivals.map((json) => StopSchedule.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load stop schedule');
    }
  }

  // Get next bus predictions for a stop
  Future<List<NextBusPrediction>> getNextBusPredictions(String stopId) async {
    final uri = Uri.parse(baseUrl);
    final url = Uri(
      scheme: uri.scheme,
      host: uri.host,
      path: '/NextBusService.svc/json/jPredictions',
      queryParameters: {'StopID': stopId},
    );
    final response = await http.get(url, headers: {'api_key': apiKey});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictions = data['Predictions'] as List?;
      if (predictions == null) return [];
      return predictions
          .map((json) => NextBusPrediction.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load next bus predictions');
    }
  }
}
