function Token(token_type, ch) constructor{
	type = token_type;
	literal = ch;
		
	#region Token Types
	enum TOKEN {
		ILLEGAL,
		EOF,
		IDENT,
	
		// Operators
		ASSIGN,
		PLUS,
	
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
	}
	#endregion
	
	
}