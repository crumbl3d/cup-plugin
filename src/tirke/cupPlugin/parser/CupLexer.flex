package tirke.cupPlugin.parser;
import com.intellij.lexer.*;
import com.intellij.psi.tree.IElementType;
import com.intellij.psi.TokenType;
import static tirke.cupPlugin.psi.CupTypes.*;

%%

%public
%class CupLexer
%implements FlexLexer
%function advance
%type IElementType
%unicode
%eof{  return;
%eof}

%state OPT_JAVA_CODE

LineTerminator = \r|\n|\r\n
WhiteSpace = [ \t]
AnySpace = {LineTerminator} | {WhiteSpace} | [\f]

Identifier = [a-zA-Z_0-9]+

Line_Comment = "//".*
Block_Comment = "/*" ~"*/"

%%
<YYINITIAL> {

  "|"                { return BAR; }
  "::="              { return CCEQ; }
  ":"                { return COLON; }
  ","                { return COMMA; }
  "{:"               { yybegin(OPT_JAVA_CODE); return  LEFTCUPBRACES; }
  ":}"               { return RIGHTCUPBRACES; }
  "("                { return LEFTPAREN; }
  ")"                { return RIGHTPAREN; }
  "."                { return DOT; }
  ";"                { return SEMI; }
  "*"                { return STAR; }
  "?"                { return QM; }
  "<"                { return LEFTI; }
  ">"                { return RIGHTI; }
  "class"            { return CLASS; }
  "import"           { return IMPORT; }
  "package"          { return PACKAGE; }
  "extends"          { return EXTENDS; }
  "super"            { return SUPER; }
  "static"           { return STATIC; }
  "action"           { return ACTION; }
  "code"             { return CODE; }
  "init"             { return INIT; }
  "parser"           { return PARSER; }
  "scan"             { return SCAN; }
  "start"            { return START; }
  "with"             { return WITH; }
  "non"              { return NON; }
  "nonterminal"      { return NONTERMINAL; }
  "terminal"         { return TERMINAL; }
  "left"             { return LEFT; }
  "nonassoc"         { return NONASSOC; }
  "%prec"            { return PERCENT_PREC; }
  "precedence"       { return PRECED; }
  "right"            { return RIGHT; }
  "JAVA_CODE"        { return JAVA_CODE; }


  {Identifier}       { return IDENTIFIER; }
  {Block_Comment}    { return BLOCK_COMMENT; }
  {Line_Comment}     { return LINE_COMMENT; }

  //Special

  {AnySpace}       { return TokenType.WHITE_SPACE; }
  [^]              { return TokenType.BAD_CHARACTER; }
}

<OPT_JAVA_CODE> {
    ":}"                   { yybegin(YYINITIAL); yypushback(yylength()); }
    [^]                    { yybegin(OPT_JAVA_CODE); return JAVA; }
}
