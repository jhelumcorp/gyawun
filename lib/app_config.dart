AppConfig appConfig = AppConfig(version: 23, codeName: '2.0.0-beta-3');

class AppConfig {
  int version;
  String codeName;
  Uri updateUri =
      Uri.parse('https://api.github.com/repos/jhelumcorp/gyawun/releases');
  AppConfig({required this.version, required this.codeName});
}
