function Token(token_type=TOKEN.ILLEGAL, ch="") constructor{
	type = token_type;
	literal = ch;
	
	keywords = ds_map_create();
	
	#region Token Types
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
	
	keywords["fn"] = TOKEN.FUNCTION;
	keywords["let"] = TOKEN.LET	;
	keywords["true"] = TOKEN.TRUE;
	keywords["false"] = TOKEN.FALSE;
	keywords["if"] = TOKEN.IF;
	keywords["else"] = TOKEN.ELSE;
	keywords["return"] = TOKEN.RETURN;

	#endregion
	
	Lookup_Ident = function(ident){
		if(!is_undefined(keywords[? ident])) return keywords[? ident];
		
		return TOKEN.IDENT;
	}
}