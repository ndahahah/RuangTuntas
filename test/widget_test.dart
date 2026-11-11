import 'package:flutter_test/flutter_test.dart';
import 'package:uts_indah_susanti_079/main.dart';

void main() {
  testWidgets('RuangTuntas menampilkan halaman utama', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RuangTuntasApp());

    expect(find.text('RuangTuntas'), findsOneWidget);
    expect(find.text('Selamat Datang di RuangTuntas!'), findsOneWidget);
  });
}
