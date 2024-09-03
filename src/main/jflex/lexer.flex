package lyc.compiler;

import java_cup.runtime.Symbol;
import lyc.compiler.ParserSym;
import lyc.compiler.model.*;
import static lyc.compiler.constants.Constants.*;
import lyc.compiler.simbolsTable.SimbolTable;
import lyc.compiler.simbolsTable.SimbolRow;

%%

%public
%class Lexer
%unicode
%cup
%line
%column
%throws CompilerException
%eofval{
  return symbol(ParserSym.EOF);
%eofval}

%{ 
  SimbolTable simbolTable = SimbolTable.getSingletonInstance();
%}

%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
  private void addSymbol(String id, Object value) {  
    SimbolRow simbolRow = new SimbolRow(id, value.toString(),"",0);
    simbolTable.setSimbol(simbolRow);
  }
%}


LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
Identation =  [ \t\f]

/* temas comunes */
While = "while" | "mientras"

If = "if"|"si"
Else = "else"|"sino"

Init = "init"


Int =  "Int"
Float = "Float"
String = "String"

Not = "!" | NOT
And = "&&" | AND
Or = "||" | OR

Write = "write"|"escribir"
Read = "read"|"leer"

OpGreater = ">"
OpLesser= "<"
OpGreaterEqual = ">="
OpLesserEqual = "<="
OpEqual = "=="
OpNotEqual = "!="
OpAssig = "=" | ":="

Plus = "+"
Mult = "*"
Sub = "-"
Div = "/"

Space = " "
Comma = ","
Dot = "."
Colon = ":"

OpenBracket = "("
CloseBracket = ")"
OpenKeyBracket = "{"
CloseKeyBracket = "}"
OpenSquareBracket = "["
CloseSquareBracket = "]"
Comillas = "\"" | "“" | "”"

Triangle = "triangle"
BinaryCount = "binaryCount"

LetterLowerCase = [a-z]
Letter = [a-zA-Z]
Digit = [0-9]
ConstInt = {Digit}+
ConstFloat = {Digit}{1,8}{Dot}{Digit}{1,8} | {Digit}{1,8} +{Dot} | {Dot}{Digit}{1,8}+
ConstString = {Comillas}([^*])*{Comillas}
Comment = ("/*" [^*] ~"*/" | "/*" "*"+ "/") | ("*-" [^*] ~"-*" | "*-" "-"+ "*")

WhiteSpace = {LineTerminator} | {Identation} | {Space}
Identifier = {LetterLowerCase} ({Letter}|{Digit})*

%%

/* keywords */

<YYINITIAL> {
  {Comment}                                 { /* ignore */ }

  {If}                                      {  return symbol(ParserSym.IF); }
  {Else}                                    { return symbol(ParserSym.ELSE); }
  {Triangle}                                { return symbol(ParserSym.TRIANGLE); }
  {BinaryCount}                             { return symbol(ParserSym.BINARY_COUNT); }
  {Write}                                   { return symbol(ParserSym.WRITE); }
  {Read}                                    { return symbol(ParserSym.READ); }

  /* operators */
  {While}                                   { return symbol(ParserSym.WHILE); }
  {If}                                      { return symbol(ParserSym.IF); }
  {Else}                                    { return symbol(ParserSym.ELSE); }
  {Init}                                    { return symbol(ParserSym.INIT, yytext()); }
  /* identifiers */
  {Identifier}                              { if(yylength() > MAX_LENGTH){ throw new InvalidLengthException(yytext()); } return symbol(ParserSym.IDENTIFIER, yytext()); }
  /* Constants */

  {ConstFloat}                              { return symbol(ParserSym.CONST_FLOAT, yytext()); }
  {ConstInt}                                {
          int value;
                              try {
                                  value = Integer.parseInt(yytext());
                                  } catch (NumberFormatException e) {
                                      throw new InvalidIntegerException(yytext());
                                  }


          if(value >= 65536) { throw new InvalidIntegerException(yytext()); } else {  return symbol(ParserSym.CONST_INT, yytext());} }
  {ConstString}                             { if(yylength() > MAX_LENGTH){ throw new InvalidLengthException(yytext()); } return symbol(ParserSym.CONST_STRING, yytext()); }
  {Comment}                                 { return symbol(ParserSym.COMMENT); }

  /* operators */

  {While}                                   { return symbol(ParserSym.WHILE); }
  {Init}                                    { return symbol(ParserSym.INIT); }
  {Int}                                     { return symbol(ParserSym.INT); }
  {Float}                                   { return symbol(ParserSym.FLOAT); }
  {String}                                  { return symbol(ParserSym.STRING, yytext()); }
  {Not}                                     { return symbol(ParserSym.NOT); }
  {And}                                     { return symbol(ParserSym.AND); }
  {Or}                                      { return symbol(ParserSym.OR); }
  {OpGreater}                               { return symbol(ParserSym.OP_GREATER); }
  {OpLesser}                                { return symbol(ParserSym.OP_LESSER); }
  {OpGreaterEqual}                          { return symbol(ParserSym.OP_GREATER_EQUAL); }
  {OpLesserEqual}                           { return symbol(ParserSym.OP_LESSER_EQUAL); }
  {OpEqual}                                 { return symbol(ParserSym.OP_EQUAL); }
  {OpNotEqual}                              { return symbol(ParserSym.OP_NOT_EQUAL); }
  {OpAssig}                                 { return symbol(ParserSym.OP_ASSIG); }
  {Plus}                                    { return symbol(ParserSym.PLUS); }
  {Sub}                                     { return symbol(ParserSym.SUB); }
  {Mult}                                    { return symbol(ParserSym.MULT); }
  {Div}                                     { return symbol(ParserSym.DIV); }
  {Comma}                                   { return symbol(ParserSym.COMMA); }
  {Dot}                                     { return symbol(ParserSym.DOT); }
  {Colon}                                   { return symbol(ParserSym.COLON); }
  {OpenKeyBracket}                          { return symbol(ParserSym.OPEN_KEY_BRACKET); }
  {CloseKeyBracket}                         { return symbol(ParserSym.CLOSE_KEY_BRACKET); }
  {OpenBracket}                             { return symbol(ParserSym.OPEN_BRACKET); }
  {CloseBracket}                            { return symbol(ParserSym.CLOSE_BRACKET); }
  {OpenSquareBracket}                       { return symbol(ParserSym.OPEN_SQUARE_BRACKET); }
  {CloseSquareBracket}                      { return symbol(ParserSym.CLOSE_SQUARE_BRACKET); }

  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }
}


/* error fallback */
[^]                              { throw new UnknownCharacterException(yytext()); }