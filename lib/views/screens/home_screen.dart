import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../utils/weather_icon_helper.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../widgets/daily_item.dart';
import '../widgets/glass_card.dart';
import '../widgets/hourly_item.dart';
import '../widgets/weather_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load weather on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherViewModel>().loadWeather('Peja');
    });

    _tabController.addListener(() {
      context.read<WeatherViewModel>().selectTab(_tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const WeatherDrawer(),
      body: Consumer<WeatherViewModel>(
        builder: (context, vm, _) {
          final gradient = vm.currentWeather != null
              ? WeatherIconHelper.conditionToGradient(
                  vm.currentWeather!.description)
              : AppColors.backgroundGradient;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradient,
              ),
            ),
            child: SafeArea(
              child: Builder(
                builder: (_) {
                  if (vm.isLoading) return _buildLoading();
                  if (vm.hasError) return _buildError(vm);
                  return _buildContent(vm);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // ----------------------------------------------------------------
  // Main content
  // ----------------------------------------------------------------
  Widget _buildContent(WeatherViewModel vm) {
    final weather = vm.currentWeather;

    return Column(
      children: [
        _buildTopBar(weather?.cityName ?? 'Weather'),
        const SizedBox(height: 24),
        _buildWeatherHero(vm),
        const SizedBox(height: 32),
        Expanded(child: _buildForecastCard(vm)),
      ],
    );
  }

  // ----------------------------------------------------------------
  // Top bar: location pin | city name | hamburger menu
  // ----------------------------------------------------------------
  Widget _buildTopBar(String city) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined,
              color: AppColors.textPrimary, size: 22),
          const Spacer(),
          Text(
            city,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
            child: const Icon(Icons.menu,
                color: AppColors.textPrimary, size: 26),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // Hero section: big icon, condition, temperature, H/L
  // ----------------------------------------------------------------
  Widget _buildWeatherHero(WeatherViewModel vm) {
    final weather = vm.currentWeather;
    final today = vm.dailyForecast.isNotEmpty ? vm.dailyForecast.first : null;

    return Column(
      children: [
        // Large weather icon
        Text(
          WeatherIconHelper.getEmoji(weather?.description ?? 'Partly Cloudy'),
          style: const TextStyle(fontSize: 90),
        ),
        const SizedBox(height: 12),

        // Condition label
        Text(
          weather?.description ?? '—',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),

        // Current temperature — large
        Text(
          weather != null
              ? '${vm.convertTemp(weather.temperature).toInt()}${vm.unitLabel}'
              : '—',
          style: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w300,
            color: AppColors.textPrimary,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),

        // High / Low
        Text(
          today != null
              ? '${vm.convertTemp(today.high).toInt()}${vm.unitLabel} / ${vm.convertTemp(today.low).toInt()}${vm.unitLabel}'
              : '—/—',
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------------
  // Forecast card: tabbed Hourly / Daily
  // ----------------------------------------------------------------
  Widget _buildForecastCard(WeatherViewModel vm) {
    return GlassCard(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
      child: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHourlyGrid(vm),
                _buildDailyList(vm),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // Tab bar — Hourly | Daily with purple active underline
  // ----------------------------------------------------------------
  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'Hourly Forecast'),
        Tab(text: 'Daily Forecast'),
      ],
      labelColor: AppColors.textPrimary,
      unselectedLabelColor: AppColors.textMuted,
      indicatorColor: AppColors.tabActive,
      indicatorWeight: 3,
      dividerColor: AppColors.tabInactive,
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // ----------------------------------------------------------------
  // Hourly grid — 3 columns matching Figma layout
  // ----------------------------------------------------------------
  Widget _buildHourlyGrid(WeatherViewModel vm) {
    final items = vm.hourlyForecast;

    if (items.isEmpty) {
      return const Center(
          child: Text('No hourly data', style: TextStyle(color: AppColors.textMuted)));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => HourlyItem(
        item: items[i],
        isNow: i == 0,
        convertTemp: vm.convertTemp,
        unitLabel: vm.unitLabel,
      ),
    );
  }

  // ----------------------------------------------------------------
  // Daily list — one row per day with dividers
  // ----------------------------------------------------------------
  Widget _buildDailyList(WeatherViewModel vm) {
    final items = vm.dailyForecast;

    if (items.isEmpty) {
      return const Center(
          child: Text('No daily data', style: TextStyle(color: AppColors.textMuted)));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      itemBuilder: (_, i) => DailyItem(
        item: items[i],
        showDivider: i < items.length - 1,
        convertTemp: vm.convertTemp,
        unitLabel: vm.unitLabel,
      ),
    );
  }

  // ----------------------------------------------------------------
  // Loading & error states
  // ----------------------------------------------------------------
  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.textPrimary),
    );
  }

  Widget _buildError(WeatherViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, color: AppColors.textMuted, size: 56),
            const SizedBox(height: 16),
            Text(
              vm.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => vm.loadWeather('Peja'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cardBackground,
                foregroundColor: AppColors.textPrimary,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
