import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_profile.dart';
import 'reports.dart';
import 'image_model.dart';
import 'image_model_doc.dart';
// import 'comments.dart';

class ApiService {
  static const String baseUrl = 'http://51.20.3.117';
  
  Future<UserProfile> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/user_details/'),
      headers: {'Authorization': 'Token $token'},
    );
    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<List<UserReport>> fetchUserReports(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/images/reports/'),
      headers: {'Authorization': 'Token $token'},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => UserReport.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user reports');
    }
  }

  Future<Map<String, dynamic>> fetchUserData(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/user_details/'),
      headers: {'Authorization': 'Token $token'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data: ${response.statusCode}');
    }
  }

  Future<ImageData> fetchReportData(String reportStaticId) async {
    final String reportsApiUrl = '$baseUrl/images/reports_details/$reportStaticId/';
    final response = await http.get(Uri.parse(reportsApiUrl));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      return ImageData.fromJson(responseData);
    } else {
      throw Exception('Failed to load report data: ${response.statusCode}');
    }
  }

  Future<ImageDocData> fetchReportDocData(String reportStaticId) async {
    final String reportsApiUrl = '$baseUrl/images/reports_details/$reportStaticId/';
    final response = await http.get(Uri.parse(reportsApiUrl));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      return ImageDocData.fromJson(responseData);
    } else {
      throw Exception('Failed to load report data: ${response.statusCode}');
    }
  }

  Future<void> updateDoctorCommentsU(String staticId, String comments) async {
  final String baseUrl = "http://51.20.3.117";  // Replace with your actual base URL
  final String updateCommentsUrl = '$baseUrl/images/doc_comments/$staticId/';

  final body = {'doctor_comments': comments};
  print(updateCommentsUrl);
  try {
    final response = await http.patch(
      Uri.parse(updateCommentsUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('Doctor comments updated successfully');
    } else {
      throw Exception('Failed to update doctor comments: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to update doctor comments: $e');
  }
}
}
