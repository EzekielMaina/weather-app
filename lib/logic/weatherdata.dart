import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';

WeatherFactory wf = WeatherFactory("7ac13eaee0873339a44e49a307dafe8c");

class WeatherScreen extends StatelessWidget {
  final String cityName;

  const WeatherScreen({Key? key, required this.cityName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Smart Weather',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: false,
          backgroundColor: Colors.black, // Change the background color
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white) // Remove the shadow
          ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.lightBlueAccent],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<Weather>(
            future: wf.currentWeatherByCityName(cityName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData) {
                return Center(
                  child: Text('No data available'),
                );
              }

              Weather weather = snapshot.data!;
              double? celsius = weather.temperature?.celsius;
              double? fahrenheit = weather.temperature?.fahrenheit;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Current Weather in $cityName',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Temperature: ${celsius!.toStringAsFixed(1)}°C / ${fahrenheit!.toStringAsFixed(1)}°F',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    Icon(
                      getWeatherIcon(weather.weatherDescription ?? ''),
                      size: 80,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Clouds: ${weather.weatherDescription}',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Humidity: ${weather.humidity}%',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Wind Speed: ${weather.windSpeed} m/s',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    SizedBox(height: 30),
                    Text(
                      '$cityName Weather Forecast',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 200,
                      child: FutureBuilder<List<Weather>>(
                        future: wf.fiveDayForecastByCityName(cityName),
                        builder: (context, forecastSnapshot) {
                          if (forecastSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (forecastSnapshot.hasError) {
                            return Text('Error: ${forecastSnapshot.error}',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.red));
                          } else if (!forecastSnapshot.hasData ||
                              forecastSnapshot.data!.isEmpty) {
                            return Text('No forecast data available',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white));
                          }

                          List<Weather> forecast = forecastSnapshot.data!;

                          // Filter unique days
                          List<Weather> uniqueDaysForecast = [];

                          forecast.forEach((item) {
                            if (!uniqueDaysForecast.any(
                                (day) => isSameDay(day.date!, item.date!))) {
                              uniqueDaysForecast.add(item);
                            }
                          });

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: uniqueDaysForecast.length,
                            itemBuilder: (context, index) {
                              Weather forecastItem = uniqueDaysForecast[index];
                              return WeatherForecastCard(
                                forecastItem: forecastItem,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

IconData getWeatherIcon(String s) {
  switch (s.toLowerCase()) {
    case 'clear':
      return WeatherIcons.day_sunny;
    case 'rain':
      return WeatherIcons.rain;
    case 'clouds':
      return WeatherIcons.cloudy;
    // Add more cases for other weather conditions
    default:
      return WeatherIcons.cloudy;
  }
}

class WeatherForecastCard extends StatelessWidget {
  final Weather forecastItem;

  const WeatherForecastCard({
    Key? key,
    required this.forecastItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 250,
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            getDayOfWeek(forecastItem.date!),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          SizedBox(height: 8),
          Icon(
            getWeatherIcon(forecastItem.weatherDescription ?? ''),
            size: 40,
            color: Colors.blue,
          ),
          SizedBox(height: 8),
          Text(
            'Temperature: ${forecastItem.temperature?.celsius?.toStringAsFixed(1)}°C',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            'Humidity: ${forecastItem.humidity}%',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            'Wind Speed: ${forecastItem.windSpeed} m/s',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  String getDayOfWeek(DateTime date) {
    final dayOfWeek = date.weekday;
    switch (dayOfWeek) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  IconData getWeatherIcon(String weatherDescription) {
    switch (weatherDescription.toLowerCase()) {
      case 'clear':
        return WeatherIcons.day_sunny;
      case 'rain':
        return WeatherIcons.rain;
      case 'clouds':
        return WeatherIcons.cloudy;
      // Add more cases for other weather conditions
      default:
        return WeatherIcons.cloudy;
    }
  }
}

// Add this function to check if two DateTime objects represent the same day
bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}
