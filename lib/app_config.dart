AppConfig appConfig = AppConfig(version: 38, codeName: '2.0.13');

class AppConfig {
  int version;
  String codeName;
  Uri updateUri = Uri.parse(
      'https://api.github.com/repos/jhelumcorp/gyawun/releases/latest');
  AppConfig({required this.version, required this.codeName});
}
