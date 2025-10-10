AppConfig appConfig = AppConfig(version: 39, codeName: '2.0.14');

class AppConfig {
  int version;
  String codeName;
  Uri updateUri = Uri.parse(
      'https://api.github.com/repos/jhelumcorp/gyawun/releases/latest');
  AppConfig({required this.version, required this.codeName});
}
