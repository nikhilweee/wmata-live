class BusStop {
  final String stopId;
  final String name;
  final double lat;
  final double lon;
  final List<String> routes;

  BusStop({
    required this.stopId,
    required this.name,
    required this.lat,
    required this.lon,
    required this.routes,
  });

  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      stopId: json['StopID'] as String,
      name: json['Name'] as String,
      lat: (json['Lat'] as num).toDouble(),
      lon: (json['Lon'] as num).toDouble(),
      routes: List<String>.from(json['Routes'] ?? []),
    );
  }
}

class NextBusPrediction {
  final String routeId;
  final String directionText;
  final String directionNum;
  final int minutes;
  final String vehicleId;
  final String tripId;

  NextBusPrediction({
    required this.routeId,
    required this.directionText,
    required this.directionNum,
    required this.minutes,
    required this.vehicleId,
    required this.tripId,
  });

  factory NextBusPrediction.fromJson(Map<String, dynamic> json) {
    return NextBusPrediction(
      routeId: json['RouteID'] as String,
      directionText: json['DirectionText'] as String,
      directionNum: json['DirectionNum'] as String,
      minutes: json['Minutes'] as int,
      vehicleId: json['VehicleID'] as String,
      tripId: json['TripID'] as String,
    );
  }
}

class StopSchedule {
  final DateTime scheduleTime;
  final String directionNum;
  final DateTime startTime;
  final DateTime endTime;
  final String routeId;
  final String tripDirectionText;
  final String tripHeadsign;
  final String tripId;

  StopSchedule({
    required this.scheduleTime,
    required this.directionNum,
    required this.startTime,
    required this.endTime,
    required this.routeId,
    required this.tripDirectionText,
    required this.tripHeadsign,
    required this.tripId,
  });

  factory StopSchedule.fromJson(Map<String, dynamic> json) {
    return StopSchedule(
      scheduleTime: DateTime.parse(json['ScheduleTime'] as String),
      directionNum: json['DirectionNum'] as String,
      startTime: DateTime.parse(json['StartTime'] as String),
      endTime: DateTime.parse(json['EndTime'] as String),
      routeId: json['RouteID'] as String,
      tripDirectionText: json['TripDirectionText'] as String,
      tripHeadsign: json['TripHeadsign'] as String,
      tripId: json['TripID'] as String,
    );
  }
}
