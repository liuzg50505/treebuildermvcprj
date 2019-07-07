import 'package:flutter/material.dart';

import 'package:treebuildermvc/treebuilder/base.dart';

class ColumnTreeNode extends TreeNode {
  @override
  Widget build(MetaObject context, ControllerManager controllerManager) {
    var s = this.getValue('children');
    var widgetst = buildTreeNodes(context, controllerManager, s);
    var r = Column(
      mainAxisAlignment: parseEnumProperty(context, MainAxisAlignment.values,
          MainAxisAlignment.start, this, 'mainAxisAlignment'),
      mainAxisSize: parseEnumProperty(context, MainAxisSize.values,
          MainAxisSize.max, this, 'mainAxisSize'),
      crossAxisAlignment: parseEnumProperty(
          context,
          CrossAxisAlignment.values,
          CrossAxisAlignment.center,
          this,
          'crossAxisAlignment'),
      textDirection: parseEnumProperty(context, TextDirection.values,
          TextDirection.ltr, this, 'textDirection'),
      verticalDirection: parseEnumProperty(context, VerticalDirection.values,
          VerticalDirection.down, this, 'verticalDirection'),
      textBaseline: parseEnumProperty(context, TextBaseline.values,
          TextBaseline.alphabetic, this, 'textBaseline'),

      children: widgetst.cast(),
    );

    return r;
  }

  @override
  Set<String> get properties {
    return {'children', 'mainAxisAlignment', 'mainAxisSize', 'crossAxisAlignment', 'textDirection', 'verticalDirection', 'textBaseline'};
  }

  @override
  String get NodeName => 'Column';

  @override
  TreeNode newinstance() => ColumnTreeNode();

  @override
  Set<String> get treeNodeProperties => {};

  @override
  Set<String> get treeNodesProperties => {'children'};

}

class RowTreeNode extends TreeNode {
  @override
  Widget build(MetaObject context, ControllerManager controllerManager) {
    var s = this.getValue('children');
    var widgetst = buildTreeNodes(context, controllerManager, s);
    var r = Row(
      mainAxisAlignment: parseEnumProperty(context, MainAxisAlignment.values,
          MainAxisAlignment.start, this, 'mainAxisAlignment'),
      mainAxisSize: parseEnumProperty(context, MainAxisSize.values,
          MainAxisSize.max, this, 'mainAxisSize'),
      crossAxisAlignment: parseEnumProperty(
          context,
          CrossAxisAlignment.values,
          CrossAxisAlignment.center,
          this,
          'crossAxisAlignment'),
      textDirection: parseEnumProperty(context, TextDirection.values,
          TextDirection.ltr, this, 'textDirection'),
      verticalDirection: parseEnumProperty(context, VerticalDirection.values,
          VerticalDirection.down, this, 'verticalDirection'),
      textBaseline: parseEnumProperty(context, TextBaseline.values,
          TextBaseline.alphabetic, this, 'textBaseline'),
      children: widgetst.cast(),
    );
    return r;
  }

  @override
  Set<String> get properties {
    return {'children', 'mainAxisAlignment', 'mainAxisSize', 'crossAxisAlignment', 'textDirection', 'verticalDirection', 'textBaseline'};
  }

  @override
  String get NodeName => 'Row';

  @override
  TreeNode newinstance() => RowTreeNode();

  @override
  Set<String> get treeNodeProperties => {};

  @override
  Set<String> get treeNodesProperties => {'children'};


}

class TextTreeNode extends TreeNode {
  @override
  Widget build(MetaObject context, ControllerManager controllerManager) {
    var r = Text(
      parseString(context, '', this, 'text'),
      textAlign: parseEnumProperty(context, TextAlign.values, TextAlign.left, this, 'textAlign'),
      textDirection:parseEnumProperty(context, TextDirection.values, TextDirection.ltr, this, 'textDirection'),
      overflow: parseEnumProperty(context, TextOverflow.values, TextOverflow.clip, this, 'overflow'),
      maxLines: parseInt(context, null, this, 'maxLines'),
    );
    return r;
  }

  @override
  Set<String> get properties {
    return {'text', 'textAlign', 'textDirection', 'overflow', 'maxLines'};
  }

  @override
  String get NodeName => 'Text';

  @override
  TreeNode newinstance() => TextTreeNode();

  @override
  Set<String> get treeNodeProperties => {};

  @override
  Set<String> get treeNodesProperties => {};

}

class TextFieldTreeNode extends TreeNode {
  @override
  Object build(MetaObject context, ControllerManager controllerManager) {
    var r = TextField(
      controller: TextEditingController.fromValue(TextEditingValue(
          text: parseString(context, '', this, 'text'),
          selection: TextSelection.fromPosition(
              TextPosition(affinity: TextAffinity.downstream, offset: 0)))),
      onChanged: (txt) {
        var binding = getValue('binding');
        if (binding != null) {
          context.getMetaData().set(binding, txt);
        }
      },
    );
    return r;
  }

  @override
  Set<String> get properties {
    return {'text', 'binding'};
  }

  @override
  String get NodeName => 'TextField';

  @override
  TreeNode newinstance() => TextFieldTreeNode();

  @override
  Set<String> get treeNodeProperties => {};

  @override
  Set<String> get treeNodesProperties => {};


}

class ExpandedTreeNode extends TreeNode {
  @override
  Object build(MetaObject context, ControllerManager controllerManager) {
    var r = Expanded(
      child: buildTreeNode(context, controllerManager,getValue('child')),
      flex: parseInt(context, 1, this, 'flex'),
    );
    return r;
  }

  @override
  Set<String> get properties {
    return {'child', 'flex'};
  }

  @override
  String get NodeName => 'Expanded';

  @override
  TreeNode newinstance() => ExpandedTreeNode();

  @override
  Set<String> get treeNodeProperties => {'child'};

  @override
  Set<String> get treeNodesProperties => {};

}

class AssetImageTreeNode extends TreeNode {
  @override
  Object build(MetaObject context, ControllerManager controllerManager) {
    var r = Image.asset(
      parseString(context, '', this, 'asset'),
      width: parseDouble(context, 100, this, 'width'),
      height: parseDouble(context, 100, this, 'height'),
      scale: parseDouble(context, 1, this, 'scale'),
      color: parseColor(context, null, this, 'color'),
      colorBlendMode: parseEnumProperty(
          context, BlendMode.values, BlendMode.srcIn, this, 'colorBlendMode'),
      fit: parseEnumProperty(context, BoxFit.values, null, this, 'fit'),
      alignment: parseAlignment(context,Alignment.center, this, 'alignment'),
      repeat: parseEnumProperty(
          context, ImageRepeat.values, ImageRepeat.noRepeat, this, 'repeat'),
//      centerSlice: ,
//      matchTextDirection: ,
//      gaplessPlayback: ,
    );
    return r;
  }

  @override
  Set<String> get properties {
    return {'asset', 'width', 'height', 'scale', 'color', 'colorBlendMode', 'fit', 'alignment', 'repeat'};
  }

  @override
  String get NodeName => 'AssetImage';

  @override
  TreeNode newinstance() => AssetImageTreeNode();

  @override
  Set<String> get treeNodeProperties => {};

  @override
  Set<String> get treeNodesProperties => {};


}

class SizeBoxTreeNode extends TreeNode {
  @override
  Object build(MetaObject context, ControllerManager controllerManager) {
    var r = SizedBox(
      width: parseDouble(context, null, this, 'width'),
      height: parseDouble(context, null, this, 'height'),
      child: buildTreeNode(context, controllerManager, getValue('child')),
    );
    return r;
  }

  @override
  Set<String> get properties {
    return {'child', 'width', 'height'};
  }

  @override
  String get NodeName => 'SizeBox';

  @override
  TreeNode newinstance() => SizeBoxTreeNode();

  @override
  Set<String> get treeNodeProperties => {'child'};

  @override
  Set<String> get treeNodesProperties => {};



}

class CenterTreeNode extends TreeNode {
  @override
  Object build(MetaObject context, ControllerManager controllerManager) {
    var r = Center(
      child: buildTreeNode(context, controllerManager, getValue('child')),
      widthFactor: parseDouble(context, null, this, 'widthFactor'),
      heightFactor: parseDouble(context, null, this, 'heightFactor'),
    );
    return r;
  }

  @override
  Set<String> get properties {
    return {'child', 'widthFactor', 'heightFactor'};
  }

  @override
  String get NodeName => 'Center';

  @override
  TreeNode newinstance() => CenterTreeNode();

  @override
  Set<String> get treeNodeProperties => {'child'};

  @override
  Set<String> get treeNodesProperties => {};

}

class PaddingTreeNode extends TreeNode {
  @override
  Object build(MetaObject context, ControllerManager controllerManager) {
    var r = Padding(
        child: buildTreeNode(context, controllerManager, getValue('child')),
        padding: parsePadding(context, EdgeInsets.all(0), this, 'padding'));
    return r;
  }

  @override
  Set<String> get properties {
    return {'child', 'padding'};
  }

  @override
  String get NodeName => 'Padding';

  @override
  TreeNode newinstance() => PaddingTreeNode();

  @override
  Set<String> get treeNodeProperties => {'child'};

  @override
  Set<String> get treeNodesProperties => {};

}

class AlignTreeNode extends TreeNode {
  @override
  Object build(MetaObject context, ControllerManager controllerManager) {
    var r = Align(
      child: buildTreeNode(context, controllerManager, getValue('child')),
      widthFactor: parseDouble(context, null, this, 'widthFactor'),
      heightFactor: parseDouble(context, null, this, 'heightFactor'),
      alignment: parseAlignment(context, Alignment.center, this, 'alignment'),
    );
    return r;
  }

  @override
  Set<String> get properties {
    return {'child', 'widthFactor', 'heightFactor', 'alignment'};
  }

  @override
  String get NodeName => 'Align';

  @override
  TreeNode newinstance() => AlignTreeNode();

  @override
  Set<String> get treeNodeProperties => {'child'};

  @override
  Set<String> get treeNodesProperties => {};

}

class GestureTreeNode extends TreeNode {
  @override
  Object build(MetaObject context, ControllerManager controllerManager) {
    var r = GestureDetector(
        child: buildTreeNode(context, controllerManager, getValue('child')),
        onTap: () {
          var exp = getValue('onTap');
          if(exp==null) return;
          evaluateExpression(context, exp);
        });
    return r;
  }

  @override
  Set<String> get properties {
    return {'child', 'onTap'};
  }

  @override
  String get NodeName => 'Gesture';

  @override
  TreeNode newinstance() => GestureTreeNode();

  @override
  Set<String> get treeNodeProperties => {'child'};

  @override
  Set<String> get treeNodesProperties => {};

}

class ScaffoldTreeNode extends TreeNode {
  @override
  Object build(MetaObject context, ControllerManager controllerManager) {
    var r = Scaffold(
      appBar: buildTreeNode(context, controllerManager, getValue('appBar')),
      body: buildTreeNode(context, controllerManager, getValue('body')),
      drawer: buildTreeNode(context, controllerManager, getValue('drawer')),
    );
    return r;
  }

  @override
  Set<String> get properties {
    return {'appBar', 'body', 'drawer'};
  }

  @override
  String get NodeName => 'Scaffold';

  @override
  TreeNode newinstance() => ScaffoldTreeNode();

  @override
  Set<String> get treeNodeProperties => {'appBar', 'body', 'drawer'};

  @override
  Set<String> get treeNodesProperties => {};

}

class AppBarTreeNode extends TreeNode {
  @override
  Object build(MetaObject context, ControllerManager controllerManager) {
    var r = AppBar(
      title: buildTreeNode(context, controllerManager, getValue('title')),
    );
    return r;
  }

  @override
  Set<String> get properties {
    return {'title'};
  }

  @override
  String get NodeName => 'AppBar';

  @override
  TreeNode newinstance() => AppBarTreeNode();

  @override
  Set<String> get treeNodeProperties => {'title'};

  @override
  Set<String> get treeNodesProperties => {};

}

class ListViewTreeNode extends TreeNode {
  @override
  Object build(MetaObject context, ControllerManager controllerManager) {
    var r = ListView(
      scrollDirection:parseEnumProperty(context, Axis.values, Axis.vertical, this, 'scrollDirection'),
      reverse: parseBool(context, false, this, 'reverse'),
      primary: parseBool(context, false, this, 'primary'),
      padding: parsePadding(context, EdgeInsets.all(0), this, 'padding'),
      children: buildTreeNodes(context, controllerManager, getValue('children')).cast(),
    );
    return r;
  }

  @override
  Set<String> get properties {
    return {'children'};
  }

  @override
  String get NodeName => 'ListView';

  @override
  TreeNode newinstance() => ListViewTreeNode();

  @override
  Set<String> get treeNodeProperties => {};

  @override
  Set<String> get treeNodesProperties => {'children'};

}

class RefreshIndicatorTreeNode extends TreeNode {
  @override
  Object build(MetaObject context, ControllerManager controllerManager) {
    var r = RefreshIndicator(
      child:buildTreeNode(context, controllerManager, getValue('child')),
      onRefresh: () async{
        var exp = getValue('onRefresh');
        if(exp==null) return await null;
        evaluateExpression(context, exp);
        return await null;
      },
    );
    return r;
  }

  @override
  Set<String> get properties {
    return {'child', 'onRefresh'};
  }

  @override
  String get NodeName => 'RefreshIndicator';

  @override
  TreeNode newinstance() => RefreshIndicatorTreeNode();

  @override
  Set<String> get treeNodeProperties => {'child'};

  @override
  Set<String> get treeNodesProperties => {};

}

