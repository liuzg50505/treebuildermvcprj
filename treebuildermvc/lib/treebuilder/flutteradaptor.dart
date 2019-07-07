
import 'package:flutter/material.dart';
import 'package:treebuildermvc/treebuilder/base.dart';

class WidgetAdaptor extends StatefulWidget {

  Controller controller;
  ControllerManager controllerManager;

  WidgetAdaptor(this.controller, this.controllerManager);

  @override
  State<StatefulWidget> createState() {
    return WidgetAdaptorState(controller, controllerManager);
  }
}

class WidgetAdaptorState extends State<StatefulWidget> {
  Controller controller;
  ControllerManager controllerManager;

  WidgetAdaptorState(this.controller, this.controllerManager);

  @override
  Widget build(BuildContext context) {
    controller.state = this;
    controller.buildContext = context;
    var treeNode = controllerManager.getTree(controller.controllerName);
    if(treeNode==null) throw new Exception('Tree Node <${controller.controllerName}> not Found');
    var widget = treeNode.build(controller, controllerManager);
    return widget;
  }

}