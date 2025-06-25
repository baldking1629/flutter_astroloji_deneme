import 'package:google_generative_ai/google_generative_ai.dart';

abstract class DreamRemoteDataSource {
  Future<String> analyzeDream({required String prompt});
}

class GeminiDreamRemoteDataSource implements DreamRemoteDataSource {
  final GenerativeModel _model;

  GeminiDreamRemoteDataSource(this._model);

  @override
  Future<String> analyzeDream({required String prompt}) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? "Could not get analysis.";
    } catch (e) {
      // ignore: avoid_print
      print('Error calling Gemini API: $e');
      rethrow;
    }
  }
}
