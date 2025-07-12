import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'WMATA_API_KEY')
  static final String wmataApiKey = _Env.wmataApiKey;
}
