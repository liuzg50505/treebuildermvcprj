import 'package:analyzer/dart/element/element.dart';
import 'package:glob/glob.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';

import 'package:treebuildermvc/codegenerator/mark.dart';
import 'package:path/path.dart' as path;
import 'metaobject.dart';

class MarkGenerator extends GeneratorForAnnotation<Mark> {
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {

    String className = element.displayName;
    String path = buildStep.inputId.path;
    String name =annotation.peek('name').stringValue;

    var classelem = element as ClassElement;

    var fields = classelem.fields.map((t) {
      return '${t.displayName} ${t.type}';
    } ).join(',');

    var methods = classelem.methods.map((t){
      return '${t.displayName} ${t.returnType}';
    }).join(',');

    return "//$className\n//$path\n//$name\n//$fields\n//$methods";
  }
}

class MetaGenerator extends GeneratorForAnnotation<Meta> {



  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) async {

    log.info('start meta generator');
    String className = element.displayName;
    var dartfilename = path.basename(buildStep.inputId.path);
    var l = buildStep.findAssets(new Glob(buildStep.inputId.path));
    var resolver = buildStep.resolver;
    await l.forEach((aid) async{
      LibraryElement lib;

      var libelem = await buildStep.resolver.libraryFor(aid);

    });

    var classelem = element as ClassElement;
    var getproperties = [];
    var setproperties = [];
    var propertynames = [];
    var methodnames = [];
    for(var field in classelem.fields) {
      if(field.getter!=null) getproperties.add("    if(property=='${field.displayName}') return object.${field.displayName};");
      if(field.setter!=null) setproperties.add("    if(property=='${field.displayName}') object.${field.displayName} = value;");
      propertynames.add("'${field.displayName}'");
    }
    for(var method in classelem.methods) {
      getproperties.add("    if(property=='${method.displayName}') return object.${method.displayName};");
      methodnames.add("'${method.displayName}'");
    }


    var template = """
class ${className}MetaData extends MetaObjectData {
  ${className} object;

  ${className}MetaData(this.object);

  @override
  Object get(String property) {
${getproperties.join('\n')}
    return null;
  }

  @override
  Set<String> get methods => {${methodnames.join(', ')}};

  @override
  Object newinstance() {
    return ${className}();
  }

  @override
  Set<String> get properties => {${propertynames.join(', ')}};

  @override
  void set(String property, Object value) {
${setproperties.join('\n')}
  }

}

""";
    return template;
  }


}