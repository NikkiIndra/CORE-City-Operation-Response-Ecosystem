import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/report_model.dart';

class ReportService {
  static Future<bool> sendReport(ReportModel report) async {
    try {
      final url = Uri.parse('http://192.168.43.101:5000/lapor');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(report.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
