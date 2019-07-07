import 'package:treebuildermvc/treebuilder/base.dart';
import 'package:treebuildermvc/treebuilder/treenodes.dart';

String generatorCode(TreeNode treenode, CodeGeneratorFactory factory) {
  var generator = factory.getCodeGenerator(treenode.NodeName);
  return generator.generateCode(treenode, factory);
}

abstract class CodeGenerator {
  String generateCode(TreeNode node, CodeGeneratorFactory factory);

  String get Name;
}

abstract class CodeGeneratorFactory {
  CodeGenerator getCodeGenerator(String name);
}

class RegistedCodeGeneratorFactory extends CodeGeneratorFactory{
  Map<String, CodeGenerator> _generatorMap;

  RegistedCodeGeneratorFactory() {
    _generatorMap = Map();
  }

  void regist(CodeGenerator codeGenerator) {
    _generatorMap[codeGenerator.Name] = codeGenerator;
  }

  @override
  CodeGenerator getCodeGenerator(String name) {
    if(_generatorMap.containsKey(name)){
      return _generatorMap[name];
    }
    return null;
  }

}

class TextGenerator extends CodeGenerator {
  @override
  String get Name => 'Text';

  @override
  String generateCode(TreeNode node, CodeGeneratorFactory factory) {
    var txt = node.getValue('text');
    var txt2 = 'evaluate(r"""$txt""", controller)';
    return 'Text($txt2)';
  }
}

class ColumnGenerator extends CodeGenerator {
  @override
  String get Name => 'Column';

  @override
  String generateCode(TreeNode node, CodeGeneratorFactory factory) {
    var childnodes = node.getValue('children');
    var childcodes = [];
    for(TreeNode treenode in childnodes) {
      var generator = factory.getCodeGenerator(treenode.NodeName);
      String childcode = generator.generateCode(treenode, factory);
      childcodes.add(childcode);
    }
    return 'Column(${childcodes.join(', ')})';
  }
}

class RowGenerator extends CodeGenerator {
  @override
  String get Name => 'Row';

  @override
  String generateCode(TreeNode node, CodeGeneratorFactory factory) {
    var childnodes = node.getValue('children');
    var childcodes = [];
    for(TreeNode treenode in childnodes) {
      var generator = factory.getCodeGenerator(treenode.NodeName);
      String childcode = generator.generateCode(treenode, factory);
      childcodes.add(childcode);
    }
    return 'Row(${childcodes.join(', ')})';
  }
}