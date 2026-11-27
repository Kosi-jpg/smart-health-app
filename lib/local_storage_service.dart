import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  static final FlutterSecureStorage _storage = Platform.isMacOS
      ? const FlutterSecureStorage(
          mOptions: MacOsOptions(
            usesDataProtectionKeychain: false,
          ),
        )
      : const FlutterSecureStorage();

  static String _key(String userId) => 'health_records_$userId';

  static Future<List<Map<String, dynamic>>> getRecords(
    String userId,
  ) async {
    final savedData = await _storage.read(key: _key(userId));

    if (savedData == null || savedData.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(savedData) as List;

    return decoded
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  static Future<void> saveRecords(
    String userId,
    List<Map<String, dynamic>> records,
  ) async {
    await _storage.write(
      key: _key(userId),
      value: jsonEncode(records),
    );
  }

  static Future<void> saveRecord(
    String userId,
    Map<String, dynamic> record,
  ) async {
    final records = await getRecords(userId);

    records.removeWhere(
      (item) => item['id'].toString() == record['id'].toString(),
    );

    records.insert(0, record);

    await saveRecords(userId, records);
  }

  static Future<void> deleteRecord(
    String userId,
    dynamic recordId,
  ) async {
    final records = await getRecords(userId);

    records.removeWhere(
      (item) => item['id'].toString() == recordId.toString(),
    );

    await saveRecords(userId, records);
  }
}
