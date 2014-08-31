library app_bootstrap;

import 'package:polymer/polymer.dart';

import 'colorpicker_static.dart' as i0;
import 'package:smoke/smoke.dart' show Declaration, PROPERTY, METHOD;
import 'package:smoke/static.dart' show useGeneratedCode, StaticConfiguration;

void main() {
  useGeneratedCode(new StaticConfiguration(
      checkedMode: false));
  configureForDeployment([]);
  i0.main();
}
