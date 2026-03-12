import 'dart:isolate';

Future<List<T>> parseListJsonIsolate<T>(
  T Function(Map<String, dynamic>) fromJson,
  List<dynamic> list,
) async {
  return await Isolate.run(() {
    return list.map((e) {
      return fromJson(Map<String, dynamic>.from(e));
    }).toList();
  });
}
