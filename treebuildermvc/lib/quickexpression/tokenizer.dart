
const Map<String,int> binaryOperations = const {
  '||': 1, '&&': 2, '|': 3,  '^': 4,  '&': 5,
  '==': 6, '!=': 6,
  '<=': 7,  '>=': 7, '<': 7,  '>': 7,
  '+': 9, '-': 9,
  '*': 10, '/': 10, '%': 10
};


abstract class Token {

  Token();

  String get typeName;

  String toCodeString();

  @override
  String toString() {
    return toCodeString();
  }


}

abstract class SimpleToken extends Token {
  String code;

  SimpleToken(this.code);

  @override
  String toCodeString() {
    return code;
  }

}

abstract class LiteralToken extends SimpleToken {
  LiteralToken(String code) : super(code);
}

abstract class ComposedToken extends Token {
  List<Token> tokens;

  ComposedToken(this.tokens);

}

class ParenthesesComposedToken extends ComposedToken {
  ParenthesesComposedToken(List<Token> tokens) : super(tokens);

  @override
  String toCodeString() {
    return "(${tokens.map((t)=>t.toString()).join('')})";
  }

  @override
  String get typeName => "Parentheses";

}

class FunctionParametersToken extends ComposedToken {
  FunctionParametersToken(List<Token> tokens) : super(tokens);

  @override
  String toCodeString() {
    return "(${tokens.map((t)=>t.toString()).join('')})";
  }

  @override
  String get typeName => "FunctionParameters";

}

class IndexParameterToken extends ComposedToken {
  IndexParameterToken(List<Token> tokens) : super(tokens);

  @override
  String toCodeString() {
    return "[${tokens.map((t)=>t.toString()).join('')}]";
  }

  @override
  String get typeName => "IndexParameter";

}

class OperatorToken extends SimpleToken {
  OperatorToken(String code) : super(code);

  @override
  String get typeName => "Operator";
}

class CommaToken extends SimpleToken {
  CommaToken(String code) : super(code);

  @override
  String get typeName => "Comma";
}

class IdentityToken extends SimpleToken {
  IdentityToken(String code) : super(code);

  @override
  String get typeName => "Identity";

}

class DotToken extends SimpleToken {
  DotToken(String code) : super(code);

  @override
  String get typeName => "Dot";

}

class StringToken extends LiteralToken {
  StringToken(String code) : super(code);

  @override
  String get typeName => "String";
}

class NumberToken extends LiteralToken {
  NumberToken(String code) : super(code);

  @override
  String get typeName => "Number";
}

class BoolToken extends LiteralToken {
  BoolToken(String code) : super(code);

  @override
  String get typeName => "Bool";
}

class NullToken extends LiteralToken {
  NullToken(String code) : super(code);

  @override
  String get typeName => "Null";
}

class ParenthesesStartToken extends SimpleToken {
  ParenthesesStartToken(String code) : super(code);

  @override
  String get typeName => "ParenthesesStart";

}

class ParenthesesEndToken extends SimpleToken {
  ParenthesesEndToken(String code) : super(code);

  @override
  String get typeName => "ParenthesesEnd";

}

class BracketStartToken extends SimpleToken {
  BracketStartToken(String code) : super(code);

  @override
  String get typeName => "BracketStart";
}

class BracketEndToken extends SimpleToken {
  BracketEndToken(String code) : super(code);

  @override
  String get typeName => "BracketEnd";

}

class UnTokenizedToken extends SimpleToken {
  UnTokenizedToken(String code) : super(code);

  @override
  String get typeName => "UnTokenized";
}

class Tokenizer {

  List<int> strIdxlist(String str, String substr) {
    List<int> r = List();
    int idx = str.indexOf(substr);
    while(idx>=0) {
      r.add(idx);
      idx = str.indexOf(substr, idx+substr.length);
    }
    return r;
  }

  List<Token> tokenizeStrings(String code) {
    List<Token> tokens = List();
    int pos = 0;
    bool instringtoken = false;
    for (int i = 0; i < code.length; i++) {
      var c = code.substring(i, i + 1);
      if (c == "'"||i==code.length-1) {
        if (instringtoken) {
          tokens.add(StringToken(code.substring(pos, i + 1)));
          instringtoken = false;
          pos = i + 1;
        } else {
          if(i==code.length-1) i = code.length;
          tokens.add(UnTokenizedToken(code.substring(pos, i)));
          instringtoken = true;
          pos = i;
        }
      }
    }
    return tokens;
  }

  List<Token> tokenizeStrings2(String code) {
    List<Token> tokens = List();
    int pos = 0;
    bool instringtoken = false;
    String tokenchar = null;
    String singleQuote = "'";
    String doubleQuote = '"';
    for (int i = 0; i < code.length; i++) {
      var c = code.substring(i, i + 1);

      if(!instringtoken&&(c == singleQuote||c==doubleQuote)){
        tokenchar = c;
        tokens.add(UnTokenizedToken(code.substring(pos, i)));
        instringtoken = true;
        pos = i;
      }else if(instringtoken&&c==tokenchar) {
        tokens.add(StringToken(code.substring(pos, i + 1)));
        instringtoken = false;
        pos = i + 1;
      }
    }
    if(pos<code.length-1) {
      tokens.add(UnTokenizedToken(code.substring(pos)));
    }
    return tokens;
  }

  List<Token> tokenizeParentheses(String code) {
    List<Token> tokens = List();
    int pos = 0;
    for (int i = 0; i < code.length; i++) {
      var c = code.substring(i, i + 1);
      if (c == '(') {
        tokens.add(UnTokenizedToken(code.substring(pos, i)));
        tokens.add(ParenthesesStartToken('('));
        pos = i+1;
      }else if(c==')'){
        tokens.add(UnTokenizedToken(code.substring(pos, i)));
        tokens.add(ParenthesesEndToken(')'));
        pos = i+1;
      }else if(i==code.length-1) {
        tokens.add(UnTokenizedToken(code.substring(pos)));
      }
    }
    return tokens;
  }

  List<Token> tokenizeComma(String code) {
    List<Token> tokens = List();
    int pos = 0;
    for (int i = 0; i < code.length; i++) {
      var c = code.substring(i, i + 1);
      if (c == ',') {
        tokens.add(UnTokenizedToken(code.substring(pos, i)));
        tokens.add(CommaToken(','));
        pos = i+1;
      }else if(i==code.length-1) {
        tokens.add(UnTokenizedToken(code.substring(pos)));
      }
    }
    return tokens;
  }

  List<Token> tokenizeDot(String code) {
    List<Token> tokens = List();
    int pos = 0;
    for (int i = 0; i < code.length; i++) {
      var c = code.substring(i, i + 1);
      if (c == '.') {
        tokens.add(UnTokenizedToken(code.substring(pos, i)));
        tokens.add(DotToken('.'));
        pos = i+1;
      }else if(i==code.length-1) {
        tokens.add(UnTokenizedToken(code.substring(pos)));
      }
    }
    return tokens;
  }

  List<Token> tokenizeBrackets(String code) {
    List<Token> tokens = List();
    int pos = 0;
    for (int i = 0; i < code.length; i++) {
      var c = code.substring(i, i + 1);
      if (c == '[') {
        tokens.add(UnTokenizedToken(code.substring(pos, i)));
        tokens.add(BracketStartToken('['));
        pos = i+1;
      }else if(c==']'){
        tokens.add(UnTokenizedToken(code.substring(pos, i)));
        tokens.add(BracketEndToken(']'));
        pos = i+1;
      }else if(i==code.length-1) {
        tokens.add(UnTokenizedToken(code.substring(pos)));
      }
    }
    return tokens;
  }

  List<Token> tokenizeOperators(String code) {
    var operators = binaryOperations.keys.toList();
    Map<int, String> operatormap = {};
    for(String op in operators) {
       var idxlist = strIdxlist(code, op);
       for (int idx in idxlist) {
         operatormap[idx] = op;
       }
    }
    var idxlist = operatormap.keys.toList();
    idxlist.sort();
    int pos = 0;
    List<Token> tokens = List();
    for (int idx in idxlist) {
      String op = operatormap[idx];
      int len = op.length;
      tokens.add(UnTokenizedToken(code.substring(pos, idx)));
      tokens.add(OperatorToken(op));
      pos = idx+len;
      if(idx==idxlist.last) {
        tokens.add(UnTokenizedToken(code.substring(pos)));
      }
    }
    if(tokens.isEmpty) return [UnTokenizedToken(code)];
    return tokens;
  }

  List<Token> tokenizeNumbers(String code) {
    List<Token> r = List();
    try{
      num.parse(code);
      r.add(NumberToken(code));
      return r;
    }catch(e) {
      r.add(UnTokenizedToken(code));
    }
    return r;
  }

  List<Token> tokenizeBools(String code) {
    List<Token> r = List();
      if(code.trim()=="true"||code.trim()=="false"){
        r.add(BoolToken(code));
      }else{
        r.add(UnTokenizedToken(code));
      }
    return r;
  }

  List<Token> tokenizeNulls(String code) {
    List<Token> r = List();
      if(code.trim()=="null"){
        r.add(NullToken(code));
      }else{
        r.add(UnTokenizedToken(code));
      }
    return r;
  }

  List<Token> tokenizeIdentityToken(String code) {
    List<Token> r = List();
    var newcode = code.replaceAll(' ', '');
    if(newcode.isEmpty) return r;
    r.add(IdentityToken(newcode));
    return r;
  }

  List<Token> performSubTokenize(List<Token> tokens, Function tokenfunc) {
    List<Token> r = List();
    for(Token token in tokens) {
      if(token is UnTokenizedToken) {
        var subtokens = tokenfunc(token.code);
        r.addAll(subtokens);
      }else{
        r.add(token);
      }
    }
    return r;
  }

  List<Token> composeParentheses(List<Token> tokens) {
    List<Token> r = List();
    int parenthesesLevel = 0;
    Token prevToken = null;
    bool inParentheses = false;
    List<Token> toplevelTokens = [];
    for (int i=0;i<tokens.length;i++) {
      if(parenthesesLevel==0&&tokens[i] is ParenthesesStartToken && (prevToken==null||prevToken is OperatorToken||prevToken is ParenthesesStartToken)) {
        inParentheses = true;
      }

      if(inParentheses) {
        toplevelTokens.add(tokens[i]);
      }else{
        r.add(tokens[i]);
      }

      if(tokens[i] is ParenthesesStartToken) {
        parenthesesLevel++;
      }else if(tokens[i] is ParenthesesEndToken) {
        parenthesesLevel--;
      }
      if(parenthesesLevel==0) {
        if(inParentheses) {
          var subtokens = toplevelTokens.sublist(1, toplevelTokens.length-1);
          subtokens = composeParentheses(subtokens);
          var composed = ParenthesesComposedToken(subtokens);
          r.add(composed);
          toplevelTokens.clear();
        }
        inParentheses = false;
      }
      prevToken = tokens[i];
    }
    return r;
  }

  List<Token> composeMethodCalls(List<Token> tokens) {
    List<Token> r = List();
    int parenthesesLevel = 0;
    bool inParentheses = false;
    List<Token> toplevelTokens = [];
    for (int i=0;i<tokens.length;i++) {
      if(parenthesesLevel==0&&tokens[i] is ParenthesesStartToken) {
        inParentheses = true;
      }

      if(inParentheses) {
        toplevelTokens.add(tokens[i]);
      }else{
        r.add(tokens[i]);
      }

      if(tokens[i] is ParenthesesStartToken) {
        parenthesesLevel++;
      }else if(tokens[i] is ParenthesesEndToken) {
        parenthesesLevel--;
      }
      if(parenthesesLevel==0) {
        if(inParentheses) {
          var subtokens = toplevelTokens.sublist(1, toplevelTokens.length-1);
          subtokens = composeParentheses(subtokens);
          var composed = FunctionParametersToken(subtokens);
          r.add(composed);
          toplevelTokens.clear();
        }
        inParentheses = false;
      }
    }
    for(Token token in r) {
      if(token is ComposedToken) {
        ComposedToken composedToken = token;
        composedToken.tokens = composeMethodCalls(composedToken.tokens);
      }
    }
    return r;
  }

  List<Token> composeIndexBrackets(List<Token> tokens) {
    List<Token> r = List();
    int bracketsLevel = 0;
    bool inbrackets = false;
    List<Token> toplevelTokens = [];
    for (int i=0;i<tokens.length;i++) {
      if(bracketsLevel==0&&tokens[i] is BracketStartToken) {
        inbrackets = true;
      }

      if(inbrackets) {
        toplevelTokens.add(tokens[i]);
      }else{
        r.add(tokens[i]);
      }

      if(tokens[i] is BracketStartToken) {
        bracketsLevel++;
      }else if(tokens[i] is BracketEndToken) {
        bracketsLevel--;
      }
      if(bracketsLevel==0) {
        if(inbrackets) {
          var subtokens = toplevelTokens.sublist(1, toplevelTokens.length-1);
          subtokens = composeIndexBrackets(subtokens);
          var composed = IndexParameterToken(subtokens);
          r.add(composed);
          toplevelTokens.clear();
        }
        inbrackets = false;
      }
    }
    for(Token token in r) {
      if(token is ComposedToken) {
        ComposedToken composedToken = token;
        composedToken.tokens = composeIndexBrackets(composedToken.tokens);
      }
    }
    return r;
  }


  List<ComposedToken> findComposedTokens(Token token) {
    if(token is! ComposedToken) {
      return [];
    }else{
      List<ComposedToken> r = List();
      ComposedToken composedToken = token;
      for(Token subToken in composedToken.tokens) {
        if(subToken is ComposedToken) {
          r.add(subToken);
          r.addAll(findComposedTokens(subToken));
        }
      }
      return r;
    }
  }

  List<ComposedToken> findAllComposedTokens(List<Token> tokens) {
    List<ComposedToken> r = List();
    for(Token token in tokens) {
      if(token is ComposedToken) {
        r.add(token);
        r.addAll(findComposedTokens(token));
      }
    }
    return r;
  }


  tokenize(String code) {
    List<Token> tokens = tokenizeStrings2(code);
    tokens = performSubTokenize(tokens, tokenizeParentheses);
    tokens = performSubTokenize(tokens, tokenizeBrackets);
    tokens = performSubTokenize(tokens, tokenizeOperators);
    tokens = performSubTokenize(tokens, tokenizeComma);
    tokens = performSubTokenize(tokens, tokenizeDot);
    tokens = performSubTokenize(tokens, tokenizeNumbers);
    tokens = performSubTokenize(tokens, tokenizeBools);
    tokens = performSubTokenize(tokens, tokenizeNulls);
    tokens = performSubTokenize(tokens, tokenizeIdentityToken);
    tokens = composeParentheses(tokens);
    tokens = composeMethodCalls(tokens);
    tokens = composeIndexBrackets(tokens);

//    var composedTokens = findAllComposedTokens(tokens);

    return tokens;
  }
}

void printParsedToken(Token token, int level, int indents) {
  String indentstr = '';
  for(int i=0;i<level-1;i++) {
    for(int j=0;j<indents;j++){
      indentstr+=' ';
    }
  }
  if(level>0) {
    indentstr+="|";
    for(int i=0;i<indents-1;i++) {
      indentstr+='-';
    }
  }
  if(token is ComposedToken) {
    print('${indentstr}${token.typeName.toUpperCase()}: ${token.toCodeString()}');
    ComposedToken composedToken = token;
    for(Token subToken in composedToken.tokens) {
      printParsedToken(subToken, level+1, indents);
    }
  }else{
    print('${indentstr}${token.typeName.toUpperCase()} -> ${token.toCodeString()}');
  }
}

void printParsedTokens(List<Token> tokens, [int indents=2]) {
  for(Token token in tokens) {
    printParsedToken(token, 1, indents);
  }
}

void printASTTree(String expression, [int indents=2]) {
  print('AST: ${expression}');
  Tokenizer tokenizer = Tokenizer();
  var tokens = tokenizer.tokenize(expression);
  printParsedTokens(tokens, indents);
}