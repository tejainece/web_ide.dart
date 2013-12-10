import 'package:polymer/builder.dart';
        
main(args) {
  build(entryPoints: ['examples/DockerStatic/dockerstatic.html', 'examples/DockerAddButtons/dockeraddbuttons.html'],
        options: parseOptions(args));
}
