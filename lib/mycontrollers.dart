import 'package:treebuildermvc/treebuilder/base.dart';
import 'package:treebuildermvc/codegenerator/metaobject.dart';

part 'mycontrollers.g.dart';


@Meta()
class PersonContact extends MetaObject{
  String name;
  String phonenumber1;
  String phonenumber2;

  PersonContact({this.name, this.phonenumber1, this.phonenumber2});

  @override
  MetaObjectData getMetaData() {
    return PersonContactMetaData(this);
  }
}

@Meta()
class AddressBookController extends Controller{
  String title;
  List<PersonContact> cards = [];
  int c;

  AddressBookController() {
    c=1;
  }

  onTextTap() {
    print('ontexttap');
  }

  onCardTap(PersonContact card){
    print('card tapped!');
    print('name: ${card.name}');
    c++;
    cards.add(PersonContact(name: '$c', phonenumber2: '$c',phonenumber1: '$c'));
    setState();
  }

  onRefresh() {
    print('refreshing');
  }

  onCardChanged(CardController cardController) {

  }

  @override
  String get controllerName => 'AddressBookController';

  @override
  MetaObjectData getMetaData() {
    return AddressBookControllerMetaData(this);
  }

}

@Meta()
class CardController extends Controller {

  String personname;
  String phone1;
  String phone2;

  @override
  String get controllerName => 'CardController';

  @override
  MetaObjectData getMetaData() {
    return new CardControllerMetaData(this);
  }
}

