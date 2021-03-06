import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:weather_app/application/rest_client/rest_client_weather.dart';
import 'package:weather_app/models/weather_weekly_model.dart';
import 'package:weather_app/repositories/weather_weekly/weather_weekly_repository.dart';

class WeatherWeeklyRepositoryImpl implements WeatherWeeklyRepository {
  final RestClientWeather _restClient;

  WeatherWeeklyRepositoryImpl({
    required RestClientWeather restClient,
  }) : _restClient = restClient;

  @override
  Future<List<WeatherWeeklyModel?>> getWeatherWeekly(
      String lat, String long) async {
    final result = await _restClient.get<List<WeatherWeeklyModel>>(
      '/onecall?',
      query: {
        'appid': RemoteConfig.instance.getString('api_key_openweathermap'),
        'lang': 'pt_br',
        'units': 'metric',
        'exclude': 'hourly,minutely',
        'lat': lat,
        'lon': long,
      },
      decoder: (data) {
        //pega os dados do array "daily"
        final result = data['daily'];
        //verifica se tem dados
        if (result != null) {
          //transforma a lista de CHAVExVALOR (JSON) no model WeatherWeeklyModel
          return result
              .map<WeatherWeeklyModel>((w) => WeatherWeeklyModel.fromMap(w))
              .toList();
        } else {
          //se for vazio retorna nulo
          return <WeatherWeeklyModel>[];
        }
      },
    );

    //apos executar o acesso verifica se possui algumm erro
    if (result.hasError) {
      print('Erro getWeatherWeekly [${result.statusText}]');
      throw Exception('Erro getWeatherWeekly');
    }

    return result.body ?? <WeatherWeeklyModel>[];
  }
}
