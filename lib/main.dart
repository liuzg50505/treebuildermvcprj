import 'package:flutter/material.dart';
import 'package:treebuildermvc/treebuilder/base.dart';
import 'package:treebuildermvc/treebuilder/controllermanager.dart';
import 'package:treebuildermvc/treebuilder/flutteradaptor.dart';
import 'package:treebuildermvc/treebuilder/treenodes.dart';

import 'mycontrollers.dart';

Future main() async {
  RegistryTreeNodeFactory treenodefactory = RegistryTreeNodeFactory();
  treenodefactory.registTreeNode(IfTreeNode());
  treenodefactory.registTreeNode(ForeachTreeNode());
  treenodefactory.registTreeNode(ControllerTreeNode());
  treenodefactory.registTreeNode(CodeTreeNode());
  treenodefactory.registTreeNode(ColumnTreeNode());
  treenodefactory.registTreeNode(RowTreeNode());
  treenodefactory.registTreeNode(TextTreeNode());
  treenodefactory.registTreeNode(TextFieldTreeNode());
  treenodefactory.registTreeNode(ExpandedTreeNode());
  treenodefactory.registTreeNode(AssetImageTreeNode());
  treenodefactory.registTreeNode(SizeBoxTreeNode());
  treenodefactory.registTreeNode(CenterTreeNode());
  treenodefactory.registTreeNode(PaddingTreeNode());
  treenodefactory.registTreeNode(AlignTreeNode());
  treenodefactory.registTreeNode(GestureTreeNode());
  treenodefactory.registTreeNode(ScaffoldTreeNode());
  treenodefactory.registTreeNode(AppBarTreeNode());
  treenodefactory.registTreeNode(ListViewTreeNode());
  treenodefactory.registTreeNode(RefreshIndicatorTreeNode());

  AssetControllerManager manager = AssetControllerManager(treenodefactory);
  manager.registController(AddressBookController());
  manager.registController(CardController());
  await manager.loadResource('assets/design.xml');

  AddressBookController controller = manager.newController('AddressBookController');
  controller.title = "test title string";
  controller.cards = [
    PersonContact(name: 'wang', phonenumber1: '12344422323', phonenumber2: '3234232222'),
    PersonContact(name: 'lee', phonenumber1: '4222312312', phonenumber2: '23423'),
    PersonContact(name: 'qiang', phonenumber1: '5456456456', phonenumber2: '3342'),
  ];
  WidgetAdaptor rootWidget = WidgetAdaptor(controller, manager);
  runApp(MaterialApp(home: rootWidget,));
}

