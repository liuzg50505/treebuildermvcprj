import 'package:treebuildermvc/treebuilder/base.dart';

abstract class Evaluator {
  dynamic evaluate(MetaObjectData metaObject, String exp);
}

