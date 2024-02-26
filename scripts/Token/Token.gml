#region Token Keywords
enum TOKEN {
	ILLEGAL,
	EOF,
	IDENT,
	INT,
	
	// Operators
	ASSIGN,
	PLUS,
	MINUS,
	BANG,
	ASTERISK,
	SLASH,
	GT,
	LT,
	EQ,
	NOT_EQ,
	
	// Delimeters
	COMMA,
	SEMICOLON,
	LPAREN,
	RPAREN,
	LBRACE,
	RBRACE,
	
	// Keywords
	FUNCTION,
	LET,
	TRUE,
	FALSE,
	IF,
	ELSE,
	RETURN,
}
#endregion

function Token(token_type=TOKEN.ILLEGAL, ch="") constructor{
	type = token_type;
	literal = ch;
	
	Lookup_Ident = function(ident){
		if(!is_undefined(global.keywords[$ ident])) return global.keywords[$ ident];
		
		return TOKEN.IDENT;
	}
}