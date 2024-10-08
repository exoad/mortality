import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mortality_app/core/user_profile_data.dart';
import 'package:mortality_app/debug.dart';
import 'package:mortality_app/shared.dart';

const String _kBoxName = "$kCanonicalAppIdentifier#user_profile";

class DataBoxManager extends ChangeNotifier {
  static final DataBoxManager _instance = DataBoxManager._internal();

  factory DataBoxManager() {
    return _instance;
  }

  late UserProfile _userProfile;
  late Box<dynamic> _box;

  DataBoxManager._internal();

  Future<bool> load() async {
    Debug().warn("DataBoxManager loading items from hibernation!");
    bool isNewUser = !(await Hive.boxExists(_kBoxName));
    _box = await Hive.openBox<dynamic>(_kBoxName);
    if (containsKey(UserProfileDefaults.boxName)) {
      isNewUser = false;
      _userProfile = UserProfile.fromJson(
          jsonDecode(_box.get(UserProfileDefaults.boxName)));
    } else {
      _userProfile = UserProfile(
          name: UserProfileDefaults.defaultName,
          sex: UserProfileDefaults.defaultSex,
          birthDate: UserProfileDefaults.defaultBirthDate,
          defaultUseSexBasedCalculations:
              UserProfileDefaults.defaultUseSexBasedCalculations);
      isNewUser = true;
    }
    await save();
    // uncomment to clear all data DEBUG_PURPOSES
    // await _box.clear();
    Debug().info("DataBoxManager: Loaded keys: ${_box.toMap()}");
    return isNewUser;
  }

  List<String> get keys {
    List<String> keys = <String>[];
    for (String key in _box.keys) {
      keys.add(key);
    }
    return keys;
  }

  Future<void> save() async {
    await _box.put(UserProfileDefaults.boxName, jsonEncode(_userProfile));
  }

  bool get isEmpty => _box.keys.isEmpty;

  void put(String key, dynamic value) {
    _box.put(key, value);
    notifyListeners();
  }

  void putAll(Map<String, dynamic> map) {
    _box.putAll(map);
    notifyListeners();
  }

  void remove(String key) {
    _box.delete(key);
    notifyListeners();
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
