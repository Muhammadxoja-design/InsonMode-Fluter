import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final familyRepositoryProvider = Provider((ref) => FamilyRepository());

class FamilyRepository {
  final Dio _dio = Dio();

  // Mock API for now
  Future<String> generateCode() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Generate a random 6-digit code
    final random = Random();
    final code = (100000 + random.nextInt(900000)).toString();
    return code;
  }

  Future<bool> linkTeen(String code) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simple validation mock
    if (code.length == 6) {
      return true;
    } else {
      throw Exception("Invalid code");
    }
  }
}
