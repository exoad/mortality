import 'package:hive/hive.dart';
import 'package:mortality_app/core/user_profile_data.dart';
import 'package:mortality_app/debug.dart';
import 'package:mortality_app/shared.dart';

const String _kBoxName = "$kCanonicalAppIdentifier#user_profile";

class DataBoxManager {
  static final DataBoxManager _instance = DataBoxManager._internal();

  factory DataBoxManager() {
    return _instance;
  }

  late Box<dynamic> _box;

  DataBoxManager._internal();

  Future<bool> load() async {
    Debug().warn("DataBoxManager loading items from hibernation!");
    bool isNewUser = !(await Hive.boxExists(_kBoxName));
    _box = await Hive.openBox<dynamic>(_kBoxName);
    late dynamic sb;
    if (!isEmpty) {
      sb = StringBuffer();
      for (String key in _box.keys) {
        sb.write(key);
        sb.write(":");
        sb.write(_box.get(key));
        sb.write("\n");
      }
    } else {
      sb = "[Nothing?] ";
      isNewUser = true;
    }
    if (containsKey(UserProfileDefaults.boxName)) {
      isNewUser = false;
    }
    Debug().info("DataBoxManager: Loaded keys: $sb");
    return isNewUser;
  }

  List<String> get keys {
    List<String> keys = <String>[];
    for (String key in _box.keys) {
      keys.add(key);
    }
    return keys;
  }

  bool get isEmpty => _box.keys.isEmpty;

  void put(String key, dynamic value) {
    _box.put(key, value);
  }

  dynamic get(String key) {
    return _box.get(key);
  }

  T getAs<T>(String key) {
    return _box.get(key) as T;
  }

  bool containsKey(String key) {
    return _box.containsKey(key);
  }
}
