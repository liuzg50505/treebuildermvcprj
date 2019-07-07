// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mycontrollers.dart';

// **************************************************************************
// MetaGenerator
// **************************************************************************

class PersonContactMetaData extends MetaObjectData {
  PersonContact object;

  PersonContactMetaData(this.object);

  @override
  Object get(String property) {
    if (property == 'name') return object.name;
    if (property == 'phonenumber1') return object.phonenumber1;
    if (property == 'phonenumber2') return object.phonenumber2;
    if (property == 'getMetaData') return object.getMetaData;
    return null;
  }

  @override
  Set<String> get methods => {'getMetaData'};

  @override
  Object newinstance() {
    return PersonContact();
  }

  @override
  Set<String> get properties => {'name', 'phonenumber1', 'phonenumber2'};

  @override
  void set(String property, Object value) {
    if (property == 'name') object.name = value;
    if (property == 'phonenumber1') object.phonenumber1 = value;
    if (property == 'phonenumber2') object.phonenumber2 = value;
  }
}

class AddressBookControllerMetaData extends MetaObjectData {
  AddressBookController object;

  AddressBookControllerMetaData(this.object);

  @override
  Object get(String property) {
    if (property == 'title') return object.title;
    if (property == 'cards') return object.cards;
    if (property == 'c') return object.c;
    if (property == 'controllerName') return object.controllerName;
    if (property == 'onTextTap') return object.onTextTap;
    if (property == 'onCardTap') return object.onCardTap;
    if (property == 'onRefresh') return object.onRefresh;
    if (property == 'onCardChanged') return object.onCardChanged;
    if (property == 'getMetaData') return object.getMetaData;
    return null;
  }

  @override
  Set<String> get methods =>
      {'onTextTap', 'onCardTap', 'onRefresh', 'onCardChanged', 'getMetaData'};

  @override
  Object newinstance() {
    return AddressBookController();
  }

  @override
  Set<String> get properties => {'title', 'cards', 'c', 'controllerName'};

  @override
  void set(String property, Object value) {
    if (property == 'title') object.title = value;
    if (property == 'cards') object.cards = value;
    if (property == 'c') object.c = value;
  }
}

class CardControllerMetaData extends MetaObjectData {
  CardController object;

  CardControllerMetaData(this.object);

  @override
  Object get(String property) {
    if (property == 'personname') return object.personname;
    if (property == 'phone1') return object.phone1;
    if (property == 'phone2') return object.phone2;
    if (property == 'controllerName') return object.controllerName;
    if (property == 'getMetaData') return object.getMetaData;
    return null;
  }

  @override
  Set<String> get methods => {'getMetaData'};

  @override
  Object newinstance() {
    return CardController();
  }

  @override
  Set<String> get properties =>
      {'personname', 'phone1', 'phone2', 'controllerName'};

  @override
  void set(String property, Object value) {
    if (property == 'personname') object.personname = value;
    if (property == 'phone1') object.phone1 = value;
    if (property == 'phone2') object.phone2 = value;
  }
}
