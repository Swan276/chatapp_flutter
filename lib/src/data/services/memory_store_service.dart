import 'package:injectable/injectable.dart';

@Singleton()
class MemoryStoreService {
  MemoryStoreService(Map<String, dynamic> data) : _data = data;

  final Map<String, dynamic> _data;

  @factoryMethod
  factory MemoryStoreService.init() {
    return MemoryStoreService({});
  }

  dynamic get(String key) => _data[key];

  void put(String key, dynamic value) {
    _data[key] = value;
  }

  void delete(String key) {
    _data.remove(key);
  }
}
