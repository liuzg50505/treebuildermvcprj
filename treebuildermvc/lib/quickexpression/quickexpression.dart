import 'tokenizer.dart';

Object calculate(Object left, Object right, String operator) {
  if(operator=='||'){
    return left||right;
  }else if(operator=='&&'){
    return left&&right;
  }else if(operator=='|'){
    return (left as bool)|(right as bool);
  }else if(operator=='^'){
    return (left as int)^(right as num);
  }else if(operator=='&'){
    return (left as bool)&(right as bool);
  }else if(operator=='=='){
    return left==right;
  }else if(operator=='!='){
    return left!=right;
  }else if(operator=='<='){
    return left as num<=right as num;
  }else if(operator=='>='){
    return left as num>=right as num;
  }else if(operator=='<'){
    return left as num<right as num;
  }else if(operator=='>'){
    return left as num>right as num;
  }else if(operator=='+'){
    if(left is num&& right is num) {
      return left + right;
    }else {
      return '$left$right';
    }
  }else if(operator=='-'){
    if(left is num&& right is num) {
      return left - right;
    }else {
      throw Exception('Invalid type!');
    }
  }else if(operator=='*'){
    if(left is num&& right is num) {
      return left * right;
    }else {
      throw Exception('Invalid type!');
    }
  }else if(operator=='/'){
    if(left is num&& right is num) {
      return left / right;
    }else {
      throw Exception('Invalid type!');
    }
  }else if(operator=='%'){
    if(left is num&& right is num) {
      return left % right;
    }else {
      throw Exception('Invalid type!');
    }
  }
  throw Exception('Invalid operator!');
}

abstract class MemberValueGetter {
  Object getMemberValue(Object value, String member);
}

class EvalutaionException implements Exception{

  String message;
  EvalutaionException([this.message]);

  @override
  String toString() {
    return 'EvalutaionException{message: $message}';
  }
}

abstract class EvaluationContext {
  Object get(String name);
  bool contains(String name);
  void set(String name, Object value);
}

class MapEvaluationContext extends EvaluationContext {
  Map<String, Object> _data;


  MapEvaluationContext([this._data]) {
    if(_data==null) _data = Map();
  }

  @override
  Object get(String name) {
    return _data[name];
  }

  @override
  void set(String name, Object value) {
    _data[name] = value;
  }

  @override
  bool contains(String name) {
    return _data.containsKey(name);
  }

}

abstract class QuickExpression {

  ExpressionParser expressionParser;

  Object evaluate(EvaluationContext context);

  String toCodeString();

  @override
  String toString() {
    return toCodeString();
  }


}

class ExpressionParser {

  MemberValueGetter memberValueGetter;

  ExpressionParser(this.memberValueGetter);

  QuickExpression parseExpressionText(String expresionstr) {
    Tokenizer tokenizer =  Tokenizer();
    var tokens = tokenizer.tokenize(expresionstr);
    return parseExpression(tokens);
  }

  QuickExpression parseExpression(List<Token> tokens) {
    if(tokens.any((t)=>t is OperatorToken)){
      return parseOperatorExpression(tokens)..expressionParser = this;
    }else{
      return parseMemberExpression(tokens)..expressionParser = this;
    }
  }

  QuickExpression parseOperatorExpression(List<Token> tokens) {
    List<Object> sequence = List();
    List<Token> curtokens = List();

    for(Token token in tokens) {
      if(token is OperatorToken) {
        sequence.add(parseExpression(curtokens));
        sequence.add(token);
        curtokens = List();
      }else{
        curtokens.add(token);
      }
    }
    if(curtokens.isNotEmpty) {
      sequence.add(parseExpression(curtokens));
      curtokens = List();
    }

    var prioritiesSet = sequence.where((o)=>o is OperatorToken).map((t)=>binaryOperations[(t as Token).toCodeString()]).toSet();
    var priorities = prioritiesSet.toList();
    for(int priority in priorities.reversed){
      var contains = sequence.any((o) => o is OperatorToken && binaryOperations[o.toCodeString()] == priority);
      while (contains) {
        var operatorToken = sequence.firstWhere((o) => o is OperatorToken && binaryOperations[o.toCodeString()] == priority);
        var idx = sequence.indexOf(operatorToken);
        var left = sequence[idx - 1];
        var right = sequence[idx + 1];
        var exp = BinaryExpression(left, right, operatorToken)..expressionParser = this;

        List<Object> newsequence = List();
        for (int i = 0; i < sequence.length; i++) {
          if (i == idx - 1 || i == idx || i == idx + 1) {
            newsequence.add(exp);
            i = idx + 1;
          } else {
            newsequence.add(sequence[i]);
          }
        }
        sequence = newsequence;
        contains = sequence.any((o) => o is OperatorToken &&
            binaryOperations[o.toCodeString()] == priority);
      }
      if (sequence.length == 1) {
        return sequence[0];
      }
    }
    throw Exception("ERROR");
  }

  QuickExpression parseMemberExpression(List<Token> tokens) {
    QuickExpression r = null;
      if(tokens.first is LiteralToken) {
        r = LiteralExpression(tokens.first)..expressionParser = this;
      }else if(tokens.first is IdentityToken) {
        r = IdentityExpression(tokens.first)..expressionParser = this;
      }else if(tokens.first is ParenthesesComposedToken) {
        ParenthesesComposedToken parenthesesComposedToken = tokens.first;
        r = parseExpression(parenthesesComposedToken.tokens);
      }else{
        throw Exception("error token type");
      }
    for(int i=1;i<tokens.length;i++) {
      Token token = tokens[i];
      if(token is FunctionParametersToken){
        r = CallMethodExpression(r, token)..expressionParser = this;
      }else if(token is IndexParameterToken) {
        r = IndexMethodExpression(r, token)..expressionParser = this;
      }else if(token is DotToken) {
        r = MemberExpression(r, tokens[i+1], memberValueGetter)..expressionParser = this;
        i++;
      }else{
        throw Exception("invalid token type in member expression");
      }
    }
    return r;
  }

}

class LiteralExpression extends QuickExpression {
  LiteralToken literalToken;

  LiteralExpression(this.literalToken);

  @override
  Object evaluate(EvaluationContext context) {
    if(literalToken is StringToken) {
      return literalToken.toCodeString().substring(1, literalToken.toCodeString().length-1);
    }else if(literalToken is NumberToken) {
      return num.parse(literalToken.toCodeString());
    }else if(literalToken is BoolToken) {
      return literalToken.toCodeString()=="true";
    }else if(literalToken is NullToken) {
      return null;
    }
    throw EvalutaionException("Error literal type! ${literalToken}");
  }

  @override
  String toCodeString() {
    return literalToken.toCodeString();
  }
}

class IdentityExpression extends QuickExpression {
  IdentityToken token;

  IdentityExpression(this.token);

  @override
  Object evaluate(EvaluationContext context) {
    return context.get(token.toCodeString());
  }

  @override
  String toCodeString() {
    return token.toCodeString();
  }

}

class MemberExpression extends QuickExpression {
  QuickExpression caller;
  IdentityToken memberToken;
  MemberValueGetter memberValueGetter;

  MemberExpression(this.caller, this.memberToken, this.memberValueGetter);

  @override
  Object evaluate(EvaluationContext context) {
    var v = caller.evaluate(context);
    if(v is Map){
      return v[memberToken.toCodeString()];
    }else {
      return memberValueGetter.getMemberValue(v, memberToken.toCodeString());
    }
  }

  @override
  String toCodeString() {
    return '${caller.toCodeString()}.${memberToken.toCodeString()}';
  }

}

class CallMethodExpression extends QuickExpression {
  QuickExpression caller;
  FunctionParametersToken parametersToken;

  CallMethodExpression(this.caller, this.parametersToken);

  @override
  Object evaluate(EvaluationContext context) {
    Function func = caller.evaluate(context);
    List<Object> paramvalues = List();
    for(Token paramToken in parametersToken.tokens) {
      if(paramToken is CommaToken) continue;
      var paramexp = expressionParser.parseExpression([paramToken]);
      var paramvalue = paramexp.evaluate(context);
      paramvalues.add(paramvalue);
    }
    var r = Function.apply(func, paramvalues);
    return r;
  }

  @override
  String toCodeString() {
    return '${caller.toCodeString()}${parametersToken.toCodeString()}';
  }

}

class IndexMethodExpression extends QuickExpression {
  QuickExpression caller;
  IndexParameterToken indexParameterToken;

  IndexMethodExpression(this.caller, this.indexParameterToken);

  @override
  Object evaluate(EvaluationContext context) {
    var v = caller.evaluate(context);
    var indexpression = expressionParser.parseExpression([indexParameterToken]);
    var indexvalue = indexpression.evaluate(context);
    if(v is Map){
      return v[indexvalue];
    }else if(v is List) {
      return v[indexvalue];
    }else {
      throw new Exception('');
    }
  }

  @override
  String toCodeString() {
    return '${caller.toCodeString()}${indexParameterToken.toCodeString()}';
  }

}

class BinaryExpression extends QuickExpression {
  QuickExpression left;
  QuickExpression right;
  OperatorToken operatorToken;

  BinaryExpression(this.left, this.right, this.operatorToken);

  @override
  Object evaluate(EvaluationContext context) {
    var leftvalue = left.evaluate(context);
    var rightvalue = right.evaluate(context);
    var r = calculate(leftvalue, rightvalue, operatorToken.toCodeString());
    return r;
  }

  @override
  String toCodeString() {
    return '${left.toCodeString()}${operatorToken.toCodeString()}${right.toCodeString()}';
  }


}


