import 'package:xml/xml.dart';
import 'package:treebuildermvc/treebuilder/base.dart';
import 'package:treebuildermvc/treebuilder/utils.dart';

bool isSimpleProperty(XmlElement elem, String property) {
  var attr = elem.getAttributeNode(property);
  if (attr != null) return true;
  var subelems = elem.findElements(property);
  if (subelems.length == 1) {
    var children = childElements(subelems.first);
    if (children.length > 0) {
      return false;
    }
  }
  return true;
}

TreeNode deserializeXml(TreeNodeFactory factory, XmlElement elem) {
  var node = factory.createTreeNode(elem.name.local);
  var treenodeproperties = node.treeNodeProperties;
  var treenodesproperties = node.treeNodesProperties;
  var mapproperties = node.mapProperties;
  for(String prop in node.properties) {
    if (treenodeproperties.contains(prop)) {
      var childelem = objectPropertyElem(elem, prop);
      if (childelem != null) {
        var subnode = deserializeXml(factory, childelem);
        node.setValue(prop, subnode);
      }
    } else if (treenodesproperties.contains(prop)) {
      var childelems = objectPropertyElems(elem, prop);
      List<TreeNode> childnodes = List();
      for (var childelem in childelems) {
        var subnode = deserializeXml(factory, childelem);
        if (subnode != null) childnodes.add(subnode);
      }
      node.setValue(prop, childnodes);
    } else if (mapproperties.contains(prop)) {
      Map<String, String> mapvalue = Map();
      var childelems = objectPropertyElems(elem, prop);
      for (var childelem in childelems) {
        var key = objectProperty<String>(childelem, 'key');
        var value = objectProperty<String>(childelem, 'value');
        mapvalue[key] = value;
      }
      node.setValue(prop, mapvalue);
    } else {
      var value = objectProperty<String>(elem, prop);
      node.setValue(prop, value);
    }
  }
  return node;
}

XmlElement serializeXml(TreeNodeFactory factory, TreeNode node) {
  var elem = XmlElement(XmlName(node.NodeName));
  var treenodeproperties = node.treeNodeProperties;
  var treenodesproperties = node.treeNodesProperties;
  var mapproperties = node.mapProperties;
  for (var prop in node.properties) {
    if (treenodeproperties.contains(prop)) {
      TreeNode subnode = node.getValue(prop);
      var subelem = serializeXml(factory, subnode);
      var propelem = XmlElement(XmlName(prop));
      propelem.children.add(subelem);
      elem.children.add(propelem);
    } else if (treenodesproperties.contains(prop)) {
      List<TreeNode> subnodes = node.getValue(prop);
      var propelem = XmlElement(XmlName(prop));
      for (var subnode in subnodes) {
        var subelem = serializeXml(factory, subnode);
        propelem.children.add(subelem);
      }
      elem.children.add(propelem);
    } else if (mapproperties.contains(prop)) {
      Map mapvalue = node.getValue(prop);
      var propelem = XmlElement(XmlName(prop));
      for (var key in mapvalue.keys) {
        var value = mapvalue[key];
        var mapitemelem = XmlElement(XmlName('item'));
        mapitemelem.attributes.add(XmlAttribute(XmlName('key'), key));
        mapitemelem.attributes.add(XmlAttribute(XmlName('value'), value));
        propelem.children.add(mapitemelem);
      }
      elem.children.add(propelem);
    } else {
      var value = node.getValue(prop);
      if (value != null) {
        elem.attributes.add(XmlAttribute(XmlName(prop), value));
      }
    }
  }
  return elem;
}
