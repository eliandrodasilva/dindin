import 'package:flutter_test/flutter_test.dart';
import 'package:dindin/main.dart';
import 'package:dindin/models/models.dart';
import 'package:dindin/screens/child_tabs.dart';
import 'package:dindin/screens/login_screen.dart';
import 'package:dindin/screens/parent_tabs.dart';
import 'package:dindin/screens/shared_tabs.dart';
import 'package:dindin/state/app_state.dart';

void main() {
  testWidgets(
      'Login flow, fixed 5-tab bottom bar for parent and child, blank settings, and logout',
      (tester) async {
    final appState = AppState(initialLoggedIn: false);

    await tester.pumpWidget(DinDinApp(initialState: appState));
    await tester.pumpAndSettle();

    // 1. Starts on LoginScreen with 1 parent and 2 daughters
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Carlos (Pai)'), findsOneWidget);
    expect(find.text('Helena'), findsOneWidget);
    expect(find.text('Sofia'), findsOneWidget);

    // 2. Log in as Parent -> lands on ParentHomeTab (center Home tab)
    await tester.tap(find.text('Carlos (Pai)'));
    await tester.pumpAndSettle();

    expect(find.byType(ParentHomeTab), findsOneWidget);
    expect(find.text('FILHOS CONECTADOS'), findsOneWidget);
    expect(find.text('MÉDIA & PROGRESSÃO DIÁRIA'), findsOneWidget);
    expect(find.text('TAREFAS ATIVAS'), findsOneWidget);

    // 3. Navigate Parent bottom bar tabs: Tarefas, Filhos, Config., Perfil
    await tester.tap(find.text('Tarefas'));
    await tester.pumpAndSettle();
    expect(find.byType(ParentTasksTab), findsOneWidget);

    await tester.tap(find.text('Filhos'));
    await tester.pumpAndSettle();
    expect(find.byType(ParentChildrenTab), findsOneWidget);
    expect(find.textContaining('MESADA POR MÊS'), findsOneWidget);
    expect(find.textContaining('EXTRATO DO COFRINHO'), findsOneWidget);

    await tester.tap(find.text('Config.'));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsBlankTab), findsOneWidget);

    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileTab), findsOneWidget);
    expect(find.text('Sair da conta'), findsOneWidget);

    // 4. Logout returns to LoginScreen
    await tester.tap(find.text('Sair da conta'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);

    // 5. Log in as Daughter (Helena) -> lands on ChildHomeTab
    await tester.tap(find.text('Helena'));
    await tester.pumpAndSettle();

    expect(find.byType(ChildHomeTab), findsOneWidget);
    expect(find.text('OLÁ, HELENA! ⭐'), findsOneWidget);
    expect(find.text('Meu Cofrinho'), findsOneWidget);

    // 6. Navigate Child bottom bar tabs: Tarefas, Desejos, Config., Perfil
    await tester.tap(find.text('Tarefas'));
    await tester.pumpAndSettle();
    expect(find.byType(ChildTasksTab), findsOneWidget);
    expect(find.text(TaskFrequency.diaria.label), findsWidgets);

    await tester.tap(find.text('Desejos'));
    await tester.pumpAndSettle();
    expect(find.byType(ChildWishlistTab), findsOneWidget);
    expect(find.text('LISTA DE DESEJOS & METAS'), findsOneWidget);

    await tester.tap(find.text('Config.'));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsBlankTab), findsOneWidget);

    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileTab), findsOneWidget);
  });
}
