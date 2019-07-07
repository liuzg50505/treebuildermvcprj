abstract class ObjectMeta {
  dynamic get(dynamic obj, String property);
  void set(dynamic obj, String property, Object value);
  Set<String> get properties;
  Set<String> get methods;
  dynamic newinstance();
}

class Reflector {

  Map<String, ObjectMeta> _metaMap;

  factory Reflector() =>_getInstance();
  static Reflector get instance => _getInstance();
  static Reflector _instance;
  Reflector._internal() {
    _metaMap = Map();
  }
  static Reflector _getInstance() {
    if (_instance == null) {
      _instance = new Reflector._internal();
    }
    return _instance;
  }

  ObjectMeta getObjectMeta(String name) {
    if(_metaMap.containsKey(name)) {
      return _metaMap[name];
    }
    return null;
  }

  void registMeta(String name,ObjectMeta objMeta) {
    _metaMap[name] = objMeta;
  }

}

