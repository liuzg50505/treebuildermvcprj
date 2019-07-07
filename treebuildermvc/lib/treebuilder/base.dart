
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:treebuildermvc/treebuilder/expression.dart';
import 'package:treebuildermvc/treebuilder/utils.dart';

/**
 * 元数据定义
 */
abstract class MetaObjectData {
  /**
   * 获取属性property的值
   * property: 属性名
   * return: 返回属性property的值
   */
  Object get(String property);

  /**
   * 设置属性property的值
   * property: 属性名
   * value: 属性值
   */
  void set(String property, Object value);

  /// 获取全部的属性名称
  Set<String> get properties;

  /// 获取全部的方法名称
  Set<String> get methods;

  /// 创建一个对象实例
  Object newinstance();
}

/**
 * 元数据
 */
abstract class MetaObject {
  /// 获取对象的元数据定义
  MetaObjectData getMetaData();
}

/**
 * 将字符串转换为颜色
 * code: 颜色代码
 * return: 返回flutter的颜色
 */
Color hexToColor(String code) {
  if (code == null) return null;
  if (code == "") return null;
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

dynamic evaluateExpression(MetaObject context, String expression) {
  QuickExpressionEvalutator evaluator = QuickExpressionEvalutator();
  return evaluator.evaluate(context.getMetaData(), expression);
}

dynamic evaluateLiteralExpression(MetaObject context, String expression) {
  if (expression == null) return null;
  QuickExpressionEvalutator evaluator = QuickExpressionEvalutator();
  List<String> templateParts = [];
  List<String> expList = [];
  int pos = 0;
  while (true) {
    var start = expression.indexOf('\${', pos);
    var end = expression.indexOf('}', pos);
    if (start == -1) {
      if (pos < expression.length) {
        templateParts.add(expression.substring(pos));
      }
      break;
    }
    if (start > pos) {
      templateParts.add(expression.substring(pos, start));
    }
    if (end != -1) {
      expList.add(expression.substring(start + 2, end));
      pos = end + 1;
    }
  }

  if (templateParts.length == 0 && expList.length == 1) {
    var exp = expList[0];
    return evaluator.evaluate(context.getMetaData(), exp);
  } else {
    String r = "";
    int i = 0, j = 0;
    while (i < templateParts.length || j < expList.length) {
      if (i < templateParts.length) {
        r += templateParts[i];
        i++;
      }
      if (j < expList.length) {
        var exp = expList[j];
        j++;
        var expresult = evaluator.evaluate(context.getMetaData(), exp);
        if (expresult != null) {
          r += expresult.toString();
        }
      }
    }
    return r;
  }
}

Object parseObject(MetaObject context, Object defaultvalue, TreeNode node,
    String property) {
  String str = node.getValue(property);
  if(str==null) return defaultvalue;
  return evaluateLiteralExpression(context, str);
}

String parseString(MetaObject context, String defaultvalue, TreeNode node,
    String property) {
  var r = parseObject(context, defaultvalue, node, property);
  if(r==null) {
    return defaultvalue;
  }
  return r.toString();
}

bool parseBool(MetaObject context, bool defaultvalue, TreeNode node,
    String property){
  var r = parseObject(context, defaultvalue, node, property);
  if(r==null||r is! bool) {
    return defaultvalue;
  }
  return r;
}

int parseInt(MetaObject context, int defaultvalue, TreeNode node,
    String property) {
  var r = parseObject(context, defaultvalue, node, property);
  if(r==null||r is! num) {
    return defaultvalue;
  }
  return r;
}

double parseDouble(MetaObject context, double defaultvalue, TreeNode node,
    String property) {
  var r = parseObject(context, defaultvalue, node, property);
  if(r==null||r is! num) {
    return defaultvalue;
  }
  return r;
}

T parseEnumProperty<T>(MetaObject context, Iterable<T> enumvalues,
    T defaultvalue, TreeNode node,String property) {
  String v = node.getValue(property);
  var r = getEnumFromString(enumvalues, node.getValue(property));
  if (r != null) {
    return r;
  }
  return defaultvalue;
}

Color parseColor(MetaObject context, Color defaultvalue,TreeNode node,
    String property) {
  String colorstr = parseString(context, null, node, property);
  if(colorstr==null) {
    return defaultvalue;
  }
  return hexToColor(colorstr);
}

parsePadding(MetaObject context, EdgeInsets defaultvalue, TreeNode node,
    String property) {
  var obj = parseObject(context, defaultvalue, node, property);
  if (obj == null) {
    return defaultvalue;
  }
  if(obj is String) {
    String str = obj;
    var parts = obj.split(',');
    if (parts.length == 4) {
      double p1 = double.parse(parts[0]);
      double p2 = double.parse(parts[1]);
      double p3 = double.parse(parts[2]);
      double p4 = double.parse(parts[3]);
      return EdgeInsets.fromLTRB(p1, p2, p3, p4);
    } else if (parts.length == 2) {
      double w = double.parse(parts[0]);
      double h = double.parse(parts[1]);
      return EdgeInsets.fromLTRB(w, h, w, h);
    } else if (parts.length == 1) {
      return EdgeInsets.all(double.parse(parts[0]));
    } else {
      return defaultvalue;
    }
  }else if(obj is Color){
    return obj;
  }
  return defaultvalue;
}


List<Object> buildTreeNodes(MetaObject context, ControllerManager controllerManager, List<TreeNode> nodes) {
  if(nodes==null) return [];
  List<Object> result = List();
  for(TreeNode node in nodes) {
    var subr = node.build(context, controllerManager);
    if(subr!=null) {
      if(subr is List) {
        result.addAll(subr);
      }else{
        result.add(subr);
      }
    }
  }
  return result;
}

Object buildTreeNode(MetaObject context, ControllerManager controllerManager, TreeNode node) {
  if(node==null) return null;
  var r = node.build(context, controllerManager);
  if(r!=null) {
    return r;
  }
  return null;
}

Alignment parseAlignment(MetaObject context,
    Alignment defaultvalue, TreeNode node, String property) {

  var str = parseObject(context, 'center', node, property);
  if (str == "topLeft") return Alignment.topLeft;
  if (str == "topCenter") return Alignment.topCenter;
  if (str == "topRight") return Alignment.topRight;
  if (str == "centerLeft") return Alignment.centerLeft;
  if (str == "center") return Alignment.center;
  if (str == "centerRight") return Alignment.centerRight;
  if (str == "bottomLeft") return Alignment.bottomLeft;
  if (str == "bottomCenter") return Alignment.bottomCenter;
  if (str == "bottomRight") return Alignment.bottomRight;
  return defaultvalue;
}


abstract class ControllerManager {
  Controller newController(String controllername);
  TreeNode getTree(String controllername);
}

abstract class Controller extends MetaObject {
  BuildContext buildContext;
  State state;
  String get controllerName;
  Function _onchangedcallback;

  void navigateBack() {
    Navigator.pop(buildContext);
  }

  void navigateTo(String assetXml, Controller controller) {
    Navigator.push(
      buildContext,
      new MaterialPageRoute(builder: (context) {
      }),
    );
  }

  void setState([VoidCallback callback]) {
    if(callback!=null) {
      state.setState(callback);
    }else{
      state.setState((){});
    }
  }

  void onChanged(Function callback) {
    _onchangedcallback = callback;
  }

  void notifyChanged() {
    if(_onchangedcallback!=null) {
      _onchangedcallback(this);
    }
  }

}

class MetaObjectWrapper extends MetaObject {

  MetaObject metaObject;
  Map<String, Object> mapdata;
  bool shadowFirst;

  MetaObjectWrapper(this.metaObject, {this.shadowFirst=true}){
    mapdata = Map();
  }

  @override
  MetaObjectData getMetaData() {
    return MetaObjectDataWrapper(this);
  }

}

class MetaObjectDataWrapper extends MetaObjectData {

  MetaObjectWrapper metaObjectWrapper;
  MetaObjectDataWrapper(this.metaObjectWrapper);

  @override
  Object get(String property) {
    if(metaObjectWrapper.shadowFirst) {
      if(metaObjectWrapper.mapdata.containsKey(property)) {
        return metaObjectWrapper.mapdata[property];
      }else{
        return metaObjectWrapper.metaObject.getMetaData().get(property);
      }
    }else{
      if(metaObjectWrapper.metaObject.getMetaData().properties.contains(property)) {
        return metaObjectWrapper.metaObject.getMetaData().get(property);
      }else if(metaObjectWrapper.metaObject.getMetaData().methods.contains(property)) {
        return metaObjectWrapper.metaObject.getMetaData().get(property);
      } else{
        return metaObjectWrapper.mapdata[property];
      }
    }
  }

  @override
  Set<String> get methods => getmethodnames();

  Set<String> getmethodnames() {
    Set<String> methodnames = Set();
    methodnames.addAll(metaObjectWrapper.metaObject.getMetaData().methods);
    for (String key in metaObjectWrapper.mapdata.keys){
      if(metaObjectWrapper.mapdata[key] is Function) {
        methodnames.add(key);
      }
    }
    return methodnames;
  }

  Set<String> getpropertynames() {
    Set<String> propertynames = Set();
    propertynames.addAll(metaObjectWrapper.metaObject.getMetaData().properties);
    for (String key in metaObjectWrapper.mapdata.keys){
      if(!(metaObjectWrapper.mapdata[key] is Function)) {
        propertynames.add(key);
      }
    }
    return propertynames;
  }

  @override
  Object newinstance() {
    return MetaObjectWrapper(metaObjectWrapper.metaObject.getMetaData().newinstance());
  }

  @override
  Set<String> get properties => getpropertynames();

  @override
  void set(String property, Object value) {
    if(metaObjectWrapper.metaObject.getMetaData().properties.contains(property)){
      metaObjectWrapper.metaObject.getMetaData().set(property, value);
    }else if(metaObjectWrapper.metaObject.getMetaData().properties.contains(property)){
      metaObjectWrapper.metaObject.getMetaData().set(property, value);
    }else{
      metaObjectWrapper.mapdata[property] = value;
    }
  }

}

//class ControllerWrapper extends Controller {
//
//  Controller controller;
//  Map<String, Object> _wrapperdata;
//
//  ControllerWrapper(this.controller) {
//    _wrapperdata = Map();
//  }
//
//  Object get(String property) {
//    if(_wrapperdata.containsKey(property)) return _wrapperdata[property];
//    return controller.getMetaData().get(property);
//  }
//
//  Set<String> get methods => controller.getMetaData().methods;
//
//  Set<String> get properties {
//    Set<String> p = {};
//    p.addAll(controller.getMetaData().properties);
//    p.addAll(_wrapperdata.keys);
//    return p;
//  }
//
//  void set(String property, Object value) {
//    _wrapperdata[property] = value;
//  }
//
//  Controller newinstance() {
//    return controller.getMetaData().newinstance();
//  }
//
//
//  @override
//  String get controllerName {
//    return controller.controllerName;
//  }
//
//  @override
//  BuildContext get buildContext {
//    return controller.buildContext;
//  }
//
//  @override
//  set buildContext(BuildContext value) {
//    controller.buildContext = value;
//  }
//
//  @override
//  MetaObjectData getMetaData() {
//    return ControllerWrapperMetaObject(this);
//  }
//
//}
//
//class ControllerWrapperMetaObject extends MetaObjectData {
//
//  ControllerWrapper controllerWrapper;
//
//
//  ControllerWrapperMetaObject(this.controllerWrapper);
//
//  @override
//  Object get(String property) {
//    return controllerWrapper.get(property);
//  }
//
//  @override
//  Set<String> get methods => controllerWrapper.methods;
//
//  @override
//  Object newinstance() {
//    return controllerWrapper.newinstance();
//  }
//
//  @override
//  Set<String> get properties => controllerWrapper.properties;
//
//  @override
//  void set(String property, Object value) {
//    controllerWrapper.set(property, value);
//  }
//
//}

abstract class TreeNode {
  Map<String, Object> _propertyValues;
  Set<String> _properties;


  TreeNode() {
    _propertyValues = Map();
    _properties = Set();
  }

  Object build(MetaObject context, ControllerManager controllerManager);

  Set<String> get properties {return _properties;}

  Set<String> get treeNodeProperties=> {};

  Set<String> get treeNodesProperties=> {};

  Set<String> get mapProperties=> {};


  Object getValue(String prop) {
    if(!_properties.contains(prop)) return null;
    return _propertyValues[prop];
  }

  void setValue(String prop, Object value) {
    _properties.add(prop);
    _propertyValues[prop] = value;
  }

  String get NodeName;

  TreeNode newinstance();

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    _toString(buffer, this, 0);
    return buffer.toString();
  }

  void _toString(StringBuffer buffer, TreeNode node, int level) {
    buffer.writeln('  '*level+node.NodeName);
    for(var prop in node.properties) {
      if(treeNodeProperties.contains(prop)) {
        buffer.writeln('  '*(level+1)+prop+": ");
        TreeNode childNode = node.getValue(prop);
        _toString(buffer, childNode, level+2);
      }else if(treeNodesProperties.contains(prop)) {
        buffer.writeln('  '*(level+1)+prop+": ");
        List<TreeNode> childNodes = node.getValue(prop);
        for(var childNode in childNodes) {
          _toString(buffer, childNode, level+2);
        }
      }else {
        var value = node.getValue(prop);
        if(value!=null) {
          buffer.writeln('  '*(level+1)+prop+": "+value.toString());
        }else{
//          buffer.writeln('  '*(level+1)+prop+": "+"NULL");
        }
      }
    }
  }

}

abstract class TreeNodeFactory{
  TreeNode createTreeNode(String name);
}

class RegistryTreeNodeFactory extends TreeNodeFactory {

  Map<String, TreeNode> _treeNodeMap;

  RegistryTreeNodeFactory() {
    _treeNodeMap = Map();
  }

  @override
  TreeNode createTreeNode(String name) {
    if(_treeNodeMap.containsKey(name)){
      return _treeNodeMap[name].newinstance();
    }
    return null;
  }

  void registTreeNode(TreeNode node) {
    if(node==null) return;
    _treeNodeMap[node.NodeName] = node;
  }

}


class IfTreeNode extends TreeNode {
  @override
  Object build(MetaObject context, ControllerManager controllerManager) {
    Object condition = parseObject(context, 'true', this, 'condition');
    if(condition==true) {
      return buildTreeNodes(context, controllerManager, getValue('children'));
    }
    return null;
  }

  @override
  Set<String> get properties {
    return {'condition', 'children'};
  }

  @override
  String get NodeName => 'If';

  @override
  TreeNode newinstance() => IfTreeNode();

  @override
  Set<String> get treeNodeProperties => {};

  @override
  Set<String> get treeNodesProperties => {'children'};
}

class ForeachTreeNode extends TreeNode {
  @override
  Object build(MetaObject context, ControllerManager controllerManager) {
    var result = [];
    String varname = getValue('variable');
    var collection = parseObject(context, [], this, 'collection');
    var children = getValue('children');
    for(var item in collection) {
      var subcontext = MetaObjectWrapper(context);
      subcontext.getMetaData().set(varname, item);
      var subresult = buildTreeNodes(subcontext, controllerManager, children);
      result.addAll(subresult);
    }
    return result;
  }

  @override
  Set<String> get properties {
    return {'variable', 'collection', 'children'};
  }

  @override
  String get NodeName => 'Foreach';

  @override
  TreeNode newinstance() => ForeachTreeNode();

  @override
  Set<String> get treeNodeProperties => {};

  @override
  Set<String> get treeNodesProperties => {'children'};
}

class ControllerTreeNode extends TreeNode {
  @override
  Object build(MetaObject context, ControllerManager controllerManager) {
    String controllername = getValue('controllername');
    Map<String, String> paramsMap = getValue('params');
    Controller curcontroller = controllerManager.newController(controllername);
    if(curcontroller==null) {
      throw Exception('controller name <$controllername> not found!');
    }
    curcontroller.onChanged((c){
      var exp = getValue('onChanged');
      evaluateExpression(context, exp);
    });
    for(String pname in paramsMap.keys) {
      String pvaluestr = paramsMap[pname];
      Object pvalue = evaluateLiteralExpression(context, pvaluestr);
      curcontroller.getMetaData().set(pname, pvalue);
    }

    var treeNode = controllerManager.getTree(controllername);
    return treeNode.build(curcontroller, controllerManager);
  }

  @override
  Set<String> get properties {
    return {'controllername', 'params'};
  }

  @override
  String get NodeName => 'Controller';

  @override
  TreeNode newinstance() => ControllerTreeNode();

  @override
  Set<String> get treeNodeProperties => {};

  @override
  Set<String> get treeNodesProperties => {};

  Set<String> get mapProperties=> {'params'};


}

class CodeTreeNode extends TreeNode {
  @override
  Object build(MetaObject context, ControllerManager controllerManager) {
    var r = parseObject(context, null, this, 'onBuild');
    return r;
  }

  @override
  Set<String> get properties {
    return {'onBuild'};
  }

  @override
  String get NodeName => 'Code';

  @override
  TreeNode newinstance() => CodeTreeNode();

  @override
  Set<String> get treeNodeProperties => {};

  @override
  Set<String> get treeNodesProperties => {};

}