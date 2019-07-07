import 'package:flutter/services.dart';
import 'package:treebuildermvc/treebuilder/xmlserializer.dart';
import 'package:xml/xml.dart';
import 'package:treebuildermvc/treebuilder/base.dart';
import 'package:treebuildermvc/treebuilder/utils.dart';

//abstract class ControllerManager {
//  TreeNodeFactory treeNodeFactory;
//
//  ControllerManager(this.treeNodeFactory);
//
//  Controller getController(String controllerName);
//
//  TreeNode getTree(String controllerName);
//}
//
class AssetControllerManager extends ControllerManager{
  Map<String, Controller> _controllerMap;
  Map<String, TreeNode> _treeMap;
  TreeNodeFactory treeNodeFactory;
  
  AssetControllerManager(this.treeNodeFactory) {
    _controllerMap = Map();
    _treeMap = Map();
  }

  void loadResource(String xmlassetpath) async {
    var xmlstr = await rootBundle.loadString(xmlassetpath);
    var doc = parse(xmlstr);
    var widgetselem = childElement(doc.rootElement, 'widgets');
    for (XmlElement widgetelem in childElements(widgetselem)) {
      var rootwidgetxml = firstElement(widgetelem);
      var roottreenode = deserializeXml(treeNodeFactory, rootwidgetxml);
      var controllername = widgetelem.getAttribute('controller');
      registTree(controllername, roottreenode);
    }
  }

  void registController(Controller controller) {
    _controllerMap[controller.controllerName] = controller;
  }

  void registTree(String controllerName, TreeNode treenode) {
    _treeMap[controllerName] = treenode;
  }


  @override
  TreeNode getTree(String controllerName) {
    if(_treeMap.containsKey(controllerName)) {
      return _treeMap[controllerName];
    }
    return null;
  }



  @override
  Controller newController(String controllername) {
    if(_controllerMap.containsKey(controllername)) {
      var controller = _controllerMap[controllername].getMetaData().newinstance();
      return controller;
    }
    return null;
  }

}