import 'package:flutter_test/flutter_test.dart';

import 'package:osoperacional_v2/main.dart';

void main() {
  testWidgets('HomePage mostra os 3 botões principais',
          (WidgetTester tester) async {
        // Monta o app
        await tester.pumpWidget(const MyApp());

        // Verifica se os textos dos botões aparecem
        expect(find.text('Em Andamento'), findsOneWidget);
        expect(find.text('Concluídas'), findsOneWidget);
        expect(find.text('Reportadas'), findsOneWidget);

        // Opcional: simula um clique no botão "Em Andamento"
        await tester.tap(find.text('Em Andamento'));
        await tester.pumpAndSettle();

        // Como a navegação abre a OsListPage, podemos verificar o título da AppBar
        expect(find.text('Em Andamento'), findsWidgets);
      });
}