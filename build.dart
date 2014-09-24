import 'package:polymer/builder.dart';
        
main(args) {
  build(entryPoints: ['web/property_editor/dynamic/property_editor.html',
                      'web/icon/dynamic/icon.html'],
        options: parseOptions(args));
}
