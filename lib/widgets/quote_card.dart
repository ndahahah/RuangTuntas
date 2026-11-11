import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quote_provider.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuoteProvider>(
      builder: (context, provider, child) {
        return Card(
          elevation: 0,
          color: const Color(0xFFE9EDFA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.format_quote, color: Color(0xFF5267A5)),
                    SizedBox(width: 8),
                    Text(
                      'Inspirasi Hari Ini',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5267A5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                if (provider.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (provider.errorMessage != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(provider.errorMessage!),
                      TextButton.icon(
                        onPressed: provider.fetchQuote,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  )
                else if (provider.quote != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"${provider.quote!.quote}"',
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '— ${provider.quote!.author}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: provider.fetchQuote,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Kutipan Lain'),
                        ),
                      ),
                    ],
                  )
                else
                  const Text('Belum ada kutipan.'),
              ],
            ),
          ),
        );
      },
    );
  }
}
