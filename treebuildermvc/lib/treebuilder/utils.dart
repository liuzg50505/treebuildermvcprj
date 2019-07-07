import 'package:xml/xml.dart';

abstract class ValueConverter {
  Object convert(Object value);
}

class IntConverter extends ValueConverter{
  @override
  Object convert(Object value) {
    if(value==null) return 0;
    return int.parse(value.toString());
  }
}

class StringConverter extends ValueConverter {
  @override
  Object convert(Object value) {
    if (value==null) return "";
    return value.toString();
  }
}

class DoubleConverter extends ValueConverter {
  @override
  Object convert(Object value) {
    if(value==null) return 0;
    return null;
  }
}

List<XmlElement> childElements(XmlElement elem) {
  List<XmlElement> result = List();
  for (XmlNode node in elem.children) {
    if(node is XmlElement) {
      result.add(node as XmlElement);
    }
  }
  return result;
}

XmlElement childElement(XmlElement elem, String tagName) {
  for (XmlNode node in elem.children) {
    if(node is XmlElement&& node.name.local == tagName) {
      return node;
    }
  }
  return null;
}

XmlElement firstElement(XmlElement elem) {
  for (XmlNode node in elem.children) {
    if(node is XmlElement) {
      return node as XmlElement;
    }
  }
  return null;
}

XmlElement objectPropertyElem(XmlElement objElem, String property) {
  try{
    var propelem = objElem.findElements(property).first;
    if(propelem!=null) {
      return firstElement(propelem);
    }
  }catch(Exception){}
  return null;
}

List<XmlElement> objectPropertyElems(XmlElement objElem, String property) {
  try{
    var propelem = objElem.findElements(property).first;
    if(propelem!=null) {
      return childElements(propelem);
    }
  }catch(Exception){}
  return List();
}

T objectProperty<T>(XmlElement objElem, String property) {
  var attr = objElem.getAttributeNode(property);

  if(attr!=null) {
    if(T == String) return attr.value as T;
    if(T == int) return int.parse(attr.value) as T;
    if(T == double) return double.parse(attr.value) as T;
  }else{
    try{
      var propelem = objElem.findElements(property).first;
      if(propelem!=null) {
        if(T == String) return propelem.text as T;
        if(T == int) return int.parse(propelem.text) as T;
        if(T == double) return double.parse(propelem.text) as T;
      }
    }catch(Exception){}
  }
  return null;
}

T getEnumFromString<T>(Iterable<T> values, String value) {
  for (T t in values) {
    if(t.toString().split('.').last==value) {
      return t;
    }
  }
  return null;
}
