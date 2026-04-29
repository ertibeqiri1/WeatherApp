// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
  cityName: json['cityName'] as String,
  temperature: (json['temperature'] as num).toDouble(),
  description: json['description'] as String,
  humidity: (json['humidity'] as num).toInt(),
  windSpeed: (json['windSpeed'] as num).toDouble(),
  iconCode: json['iconCode'] as String,
);

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
  'cityName': instance.cityName,
  'temperature': instance.temperature,
  'description': instance.description,
  'humidity': instance.humidity,
  'windSpeed': instance.windSpeed,
  'iconCode': instance.iconCode,
};
