import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/quote_model.dart';

class QuoteProvider extends ChangeNotifier {
  QuoteModel? _quote;
  bool _isLoading = false;
  String? _errorMessage;

  QuoteModel? get quote => _quote;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchQuote() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('https://dummyjson.com/quotes/random'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _quote = QuoteModel.fromJson(data);
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } on TimeoutException {
      _errorMessage = 'Koneksi terlalu lama. Silakan coba lagi.';
    } catch (error) {
      debugPrint('Fetch quote error: $error');
      _errorMessage = 'Gagal memuat kutipan. Periksa koneksi internet.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
