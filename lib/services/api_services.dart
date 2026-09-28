import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<dynamic>> getTasks() async {
    final response = await http.get(
      Uri.parse('$baseUrl/todos'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load tasks');
  }

  Future<dynamic> createTask(
    String title,
    bool completed,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'completed': completed,
        'userId': 1,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to create task');
  }

  Future<dynamic> updateTask(
    int id,
    String title,
    bool completed,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/todos/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'completed': completed,
        'userId': 1,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to update task');
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/todos/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}