
# Flutter Weather App

A Flutter weather app using the  [GeoLocation API](https://www.geoapify.com/) and [Weather API](https://home.openweathermap.org/).

## Getting Started

- Clone the repository and open the project in your IDE of choice.
- Run `flutter doctor` ensure dev stup is okay .
- Run `flutter pub get` to install the dependencies.
- Run `flutter run` to run the app in debug mode.


For further help with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Supported Features

- [x] Calender view
- [x] Search by city
- [x] Current weather (temperature, condition and wind speed)
- [x] Weather forecast

## App Architecture

 The app is split into the following modules:

- `api`: The api module contains the apiKey data and APIException to smoothly report erroes amid Configurations, access and retrieval.
- `logic`: The module contains the apps business logic, widgets and utility functions.
- `features`: The features module contains the splash screen feature. 


## Packages 

- [table_calendar]for creating customizable and interactive calendar widgets in Flutter
- [http]For REST API calls
- [provider] For state management, It helps to manage the state of your application efficiently
- [flutter_config]For separating configuration from code
- [weather]A dependency for fetching weather data
- [animated_text_kit] For animated text 
- [weather_icons] For weather-related icons.

**Note**: The API key has been provided in the code inside `lib/api/keys.dart`.However you can as well register from the above links for you own keys (Geopify and Weather).


## Screenshots
![Splash Screen](https://github.com/EzekielMaina/weather-app/blob/main/assets/app/splash.png)
![Home](https://github.com/EzekielMaina/weather-app/blob/main/assets/app/home.png)
![Geopify API Response](https://github.com/EzekielMaina/weather-app/blob/main/assets/app/location.png)
![Weather Data](https://github.com/EzekielMaina/weather-app/blob/main/assets/app/weather.png)
