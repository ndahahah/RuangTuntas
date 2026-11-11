import 'package:flutter/foundation.dart';

import '../models/quote_model.dart';

class QuoteProvider extends ChangeNotifier {
  QuoteModel? _quote;

  bool _isLoading = false;
  String? _errorMessage;

  QuoteModel? get quote => _quote;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> fetchQuote() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // REST API akan dihubungkan pada tahap integrasi API.
      throw UnimplementedError('REST API belum dihubungkan.');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
