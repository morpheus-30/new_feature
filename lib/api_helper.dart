import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiHelper {
  static const String baseUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  static const String apiKey = '';
  static const String initalPrompt =
      "You are a helpful assistant. Give me a list of 5 suggestions for the famous store names based on the given purchased item. They should be of the same type, like if the item is burger then it should suggest Burger King, McDonald's, etc., and they should be separated by commas. Don't include any other text, just the suggestions. Your purchased item is:";
  // static const String initalPrompt =
  //     "You are a helpful assistant. Give me a list of 5 suggestions for the given prompt, they should be of same time, like is it is an apple it should suggest orange,banana,and so on and they should be separated by commas. Don't include any other text just the suggestions. Your prompt is:";
  static Future<List<String>> getSuggestions(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": [
            {
              "role": "user",
              "content": ApiHelper.initalPrompt + prompt,
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final choices = data['choices'][0]['message']['content'];
        final suggestions = choices.split(',');
        return suggestions;
      }

      return [];
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
