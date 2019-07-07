import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'package:treebuildermvc/codegenerator/generator.dart';

Builder markBuilder(BuilderOptions options) => LibraryBuilder(MarkGenerator(),
    generatedExtension: '.mark.dart');

Builder metaBuilder(BuilderOptions options) => SharedPartBuilder([MetaGenerator()],'meta');
