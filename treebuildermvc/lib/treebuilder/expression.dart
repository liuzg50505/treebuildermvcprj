//import 'package:expressions/expressions.dart';
//import 'package:treebuildermvc/quickexpression/quickexpression.dart';
//import 'package:quickexpression/quickexpression.dart';
import 'package:quickexpression/quickexpression.dart';
import 'package:treebuildermvc/treebuilder/base.dart';
import 'package:treebuildermvc/treebuilder/expressionbase.dart';

//class MetaObjEvaluator extends ExpressionEvaluator {
//  @override
//  dynamic evalMemberExpression(MemberExpression expression,
//      Map<String, dynamic> context) {
//    if(expression.object!=null) {
//      var exp = expression.object as Expression;
//      var prop = expression.property.name;
//      var objvalue = this.eval(exp, context);
//      if(objvalue is MetaObject) {
//        var objmeta = objvalue.getMetaData();
//        return objmeta.get(prop);
//      }else{
//        throw Exception("Can't evaluate expression ${expression.object.toString()}");
//      }
//    }
//  }
//}
//
//class ExpEvaluator extends Evaluator{
//  @override
//  dynamic evaluate(MetaObjectData metaObject, String exp) {
//    Expression expression = Expression.parse(exp);
//    var context = Map<String, dynamic>();
//    for(String prop in metaObject.properties) {
//      context[prop] = metaObject.get(prop);
//    }
//    for (String method in metaObject.methods) {
//      context[method] = metaObject.get(method);
//    }
//
//    var evaluator = MetaObjEvaluator();
////    print('evaluating: $exp');
//    var r = evaluator.eval(expression, context);
////    print('result: $r');
//
//    return r;
//  }
//}
//
class MetaObjectContext extends EvaluationContext {
  MetaObjectData metaObjectData;

  MetaObjectContext(this.metaObjectData);

  @override
  bool contains(String name) {
    return metaObjectData.properties.contains(name)||
        metaObjectData.methods.contains(name);
  }

  @override
  Object get(String name) {
    return metaObjectData.get(name);
  }

  @override
  void set(String name, Object value) {
    metaObjectData.set(name, value);
  }

}

class MetaObjectMemberGetter extends MemberValueGetter {
  @override
  Object getMemberValue(Object value, String member) {
    if(value is MetaObject) {
      return value.getMetaData().get(member);
    }
    return null;
  }

}

class QuickExpressionEvalutator extends Evaluator {
  @override
  evaluate(MetaObjectData metaObjectData, String exp) {
    MetaObjectContext quickContext = MetaObjectContext(metaObjectData);

    MetaObjectMemberGetter memberGetter = MetaObjectMemberGetter();
    ExpressionParser parser = new ExpressionParser(memberGetter);
    var expression = parser.parseExpressionText(exp);
    return expression.evaluate(quickContext);
  }

}