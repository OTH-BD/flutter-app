import 'package:first_app/widgets/custom.drawer.widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:weather_icons/weather_icons.dart';


class MeteoPage extends StatefulWidget {
  const MeteoPage({Key? key}) : super(key: key);

  @override
  _MeteoPageState createState() => _MeteoPageState();
}

class _MeteoPageState extends State<MeteoPage> {
  String city = "Paris";
  List<dynamic>? forecast;

  Future<void> fetchWeather() async {
    final apiKey = kIsWeb ? '' : dotenv.env['OPENWEATHER_API_KEY'];
    print("🔑 API key from .env: $apiKey");



    if (apiKey == null || apiKey.isEmpty) {
      print("❌ API key not found. Please check .env file or provide a key.");
      return;
    }

    final url =
        "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception("Failed to load weather: ${response.body}");
      }
      final data = json.decode(response.body);
      setState(() {
        forecast = data["list"];
      });
    } catch (e) {
      print("❌ Error fetching weather: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return WeatherIcons.day_sunny;
      case 'clouds':
        return WeatherIcons.cloud;
      case 'rain':
        return WeatherIcons.rain;
      case 'drizzle':
        return WeatherIcons.sprinkle;
      case 'thunderstorm':
        return WeatherIcons.thunderstorm;
      case 'snow':
        return WeatherIcons.snow;
      case 'mist':
      case 'fog':
      case 'haze':
        return WeatherIcons.fog;
      default:
        return WeatherIcons.na;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyCustomDrawer(),
      appBar: AppBar(title: const Text("Weather Forecast")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(hintText: "Enter a city..."),
              onChanged: (value) => city = value,
              onSubmitted: (value) {
                city = value;
                fetchWeather();
              },
            ),
          ),
          ElevatedButton(
            onPressed: fetchWeather,
            child: const Text("Get Weather"),
          ),
          Expanded(
            child: forecast == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: forecast!.length,
              itemBuilder: (context, index) {
                final item = forecast![index];
                final date = DateTime.fromMillisecondsSinceEpoch(
                    item["dt"] * 1000);
                final icon = item["weather"][0]["main"].toLowerCase();
                final temp = item["main"]["temp"];
                final desc = item["weather"][0]["description"];

                return Card(
                  color: Colors.deepOrangeAccent,
                  child: ListTile(
                    leading: BoxedIcon(
                      _getWeatherIcon(icon),
                      color: Colors.white,
                      size: 36,
                    ),
                    title: Text(
                      "${DateFormat('E dd MMM HH:mm').format(date)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "$desc | ${temp.round()}°C",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}