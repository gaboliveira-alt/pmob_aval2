import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../data/repositories/supabase_item_repository.dart';
import 'controllers/items_controller.dart';
import 'screens/items_list_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ItemsController>(
      create: (_) =>
          ItemsController(repository: SupabaseItemRepository())..loadItems(),
      child: MaterialApp(
        title: 'Achados e Perdidos',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [Locale('pt', 'BR')],
        home: const ItemsListScreen(),
      ),
    );
  }
}
