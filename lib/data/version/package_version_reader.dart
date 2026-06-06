import 'package:package_info_plus/package_info_plus.dart';

abstract interface class PackageVersionReader {
  Future<String> readableVersion();
}

final class PluginPackageVersionReader implements PackageVersionReader {
  const PluginPackageVersionReader();

  @override
  Future<String> readableVersion() async {
    final info = await PackageInfo.fromPlatform();
    return '${info.version} (${info.buildNumber})';
  }
}
