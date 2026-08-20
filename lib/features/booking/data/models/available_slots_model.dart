
class AvailableDateModel {
  final DateTime date;
  final bool isAvailable;

  const AvailableDateModel({required this.date, required this.isAvailable});

  factory AvailableDateModel.fromJson(dynamic json, {int? year, int? month}) {
    if (json is String) {
      return AvailableDateModel(date: DateTime.parse(json), isAvailable: true);
    }

    final map = json as Map<String, dynamic>;
    final status = map['status']?.toString().toLowerCase();

    DateTime date;
    if (map['date'] != null) {
      date = DateTime.parse(map['date'].toString());
    } else if (map['day'] != null && year != null && month != null) {
      final day = int.tryParse(map['day'].toString()) ?? 1;
      date = DateTime(year, month, day);
    } else {
      date = DateTime.now();
    }

    return AvailableDateModel(
      date: date,
      isAvailable: status != null
          ? (status == 'available')
          : (map['is_available'] ?? map['available'] ?? true),
    );
  }


  static List<AvailableDateModel> listFromResponse(dynamic body) {
    dynamic dataMap = body;

   
    if (dataMap is Map && dataMap['data'] is Map) {
      dataMap = dataMap['data'];
    }

    if (dataMap is! Map) return [];

 
    final year = dataMap['year'] is int
        ? dataMap['year'] as int
        : int.tryParse(dataMap['year']?.toString() ?? '');
    final month = dataMap['month'] is int
        ? dataMap['month'] as int
        : int.tryParse(dataMap['month']?.toString() ?? '');

    final list =
        dataMap['dates'] ?? dataMap['available_dates'] ?? dataMap['days'] ?? [];

    if (list is! List) return [];
    return list
        .map((e) => AvailableDateModel.fromJson(e, year: year, month: month))
        .toList();
  }
}

class TimeSlotModel {
  final String time; 
  final bool isAvailable;

  const TimeSlotModel({required this.time, required this.isAvailable});

  factory TimeSlotModel.fromJson(dynamic json) {
    if (json is String) {
      return TimeSlotModel(time: json, isAvailable: true);
    }
    final map = json as Map<String, dynamic>;
    final status = map['status']?.toString().toLowerCase();
    return TimeSlotModel(
      time: (map['time'] ?? map['slot']).toString(),
      isAvailable: status != null
          ? (status == 'available')
          : (map['is_available'] ?? map['available'] ?? true),
    );
  }

  static List<TimeSlotModel> listFromResponse(dynamic body) {
    dynamic list = body;

    if (list is Map && list['data'] is Map) {
      list = list['data'];
    }

    if (list is Map) {
      list = list['slots'] ?? [];
    }

    if (list is! List) return [];
    return list.map((e) => TimeSlotModel.fromJson(e)).toList();
  }
}

