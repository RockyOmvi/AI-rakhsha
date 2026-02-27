import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PlacesService {
  final String apiKey;
  
  PlacesService({required this.apiKey});

  /// Finds the nearest police station to the given [latitude] and [longitude]
  Future<Map<String, dynamic>?> getNearestPoliceStation(double latitude, double longitude) async {
    final String url = 
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      '?location=\$latitude,\$longitude'
      '&rankby=distance'
      '&type=police'
      '&key=\$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final nearest = data['results'].first;
          
          if (kDebugMode) {
            print('Found nearest police station: ${nearest['name']}');
          }
          
          return {
            'name': nearest['name'],
            'address': nearest['vicinity'],
            'location': nearest['geometry']['location'],
            'place_id': nearest['place_id'],
          };
        } else {
          if (kDebugMode) {
            print('No police stations found nearby or API error: ${data['status']}');
          }
        }
      } else {
        if (kDebugMode) {
          print('Failed to fetch from Places API: \${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during Places API call: \$e');
      }
    }
    return null;
  }

  /// Calculates a route to the [destinationPlaceId] from the user's coordinates.
  /// In a full implementation, use 'flutter_polyline_points' to decode the route string.
  Future<List<String>> getRouteToPoliceStation(double lat, double lng, String destinationPlaceId) async {
    // Concept mock of the directions API call
    final String url = 
      'https://maps.googleapis.com/maps/api/directions/json'
      '?origin=\$lat,\$lng'
      '&destination=place_id:\$destinationPlaceId'
      '&mode=walking' // or driving based on context
      '&key=\$apiKey';
      
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          // In practice, decode data['routes'][0]['overview_polyline']['points']
          return ['EncodedPolylinePointsHere'];
        }
      }
    } catch (e) {
      if (kDebugMode) {
         print('Exception during Directions API call: \$e');
      }
    }
    return [];
  }
}
