import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_theme.dart';
import 'repositories/weather_repository.dart';
import 'services/weather_api_service.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'views/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final prefs = await SharedPreferences.getInstance();
  runApp(WeatherApp(prefs: prefs));
}

class WeatherApp extends StatelessWidget {
  final SharedPreferences prefs;

  const WeatherApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherViewModel(
            repository: WeatherRepositoryImpl(
              // Swap WeatherApiServiceStub → WeatherApiServiceImpl in Phase 3
              apiService: WeatherApiServiceStub(),
              prefs: prefs,
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashScreen(),
      ),
    );
  }
}
