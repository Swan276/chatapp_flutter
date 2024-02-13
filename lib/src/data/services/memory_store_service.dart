import 'package:injectable/injectable.dart';

@Singleton()
class MemoryStoreService {
  MemoryStoreService(Map<String, String> data) : _data = data;

  final Map<String, String> _data;

  @factoryMethod
  factory MemoryStoreService.init() {
    return MemoryStoreService({});
  }

  String? get(String key) => _data[key];

  void put(String key, String value) {
    _data[key] = value;
  }

  void delete(String key) {
    _data.remove(key);
  }
}
