library app_bootstrap;

import 'package:polymer/polymer.dart';

import 'package:dockable/icon/icon_view.dart' as i0;
import 'package:polymer/src/build/log_injector.dart';
import 'icon.dart' as i1;
import 'package:polymer/src/build/log_injector.dart';
import 'package:smoke/smoke.dart' show Declaration, PROPERTY, METHOD;
import 'package:smoke/static.dart' show useGeneratedCode, StaticConfiguration;
import 'package:dockable/icon/icon_view.dart' as smoke_0;
import 'package:polymer/polymer.dart' as smoke_1;
import 'package:observe/src/metadata.dart' as smoke_2;
abstract class _M0 {} // PolymerElement & ChangeNotifier

void main() {
  useGeneratedCode(new StaticConfiguration(
      checkedMode: false,
      getters: {
        #height: (o) => o.height,
        #heightChanged: (o) => o.heightChanged,
        #src: (o) => o.src,
        #srcChanged: (o) => o.srcChanged,
        #width: (o) => o.width,
        #widthChanged: (o) => o.widthChanged,
      },
      setters: {
        #height: (o, v) { o.height = v; },
        #src: (o, v) { o.src = v; },
        #width: (o, v) { o.width = v; },
      },
      parents: {
        smoke_0.IconView: _M0,
        _M0: smoke_1.PolymerElement,
      },
      declarations: {
        smoke_0.IconView: {
          #height: const Declaration(#height, int, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #heightChanged: const Declaration(#heightChanged, Function, kind: METHOD),
          #src: const Declaration(#src, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #srcChanged: const Declaration(#srcChanged, Function, kind: METHOD),
          #width: const Declaration(#width, int, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #widthChanged: const Declaration(#widthChanged, Function, kind: METHOD),
        },
      },
      names: {
        #height: r'height',
        #heightChanged: r'heightChanged',
        #src: r'src',
        #srcChanged: r'srcChanged',
        #width: r'width',
        #widthChanged: r'widthChanged',
      }));
  new LogInjector().injectLogsFromUrl('icon.html._buildLogs');
  configureForDeployment([
      () => Polymer.register('icon-view', i0.IconView),
    ]);
  i1.main();
}
