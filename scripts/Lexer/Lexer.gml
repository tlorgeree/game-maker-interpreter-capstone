function Lexer(input_str) constructor{
	input = input_str;
	position = 0;
	read_position = 0;
	ch = 0;
	
	Read_Char = function(){
		if(read_position >= string_length(input)) ch = 0;
		else ch = string_char_at(input, read_position);
		
		position = read_position;
		read_position++;
	}
	
	Read_Char(); // call on init
	
	Next_Token = function(lexer){
		var tok;
		
		switch(lexer.ch){
			case "=":
				tok = new Token(TOKEN.ASSIGN, lexer.ch);
				break;
			case ";":
				tok = new Token(TOKEN.SEMICOLON, lexer.ch);
				break;
			case "(":
				tok = new Token(TOKEN.LPAREN, lexer.ch);
				break;
			case ")":
				tok = new Token(TOKEN.RPAREN, lexer.ch);
				break;
			case "{":
				tok = new Token(TOKEN.LBRACE, lexer.ch);
				break;
			case "}":
				tok = new Token(TOKEN.RBRACE, lexer.ch);
				break;
			case ",":
				tok = new Token(TOKEN.COMMA, lexer.ch);
				break;
			case "+":
				tok = new Token(TOKEN.PLUS, lexer.ch);
				break;
			case 0:
				tok = new Token(TOKEN.EOF, "");
				break;
			default:
				tok = new Token(TOKEN.ILLEGAL, lexer.ch);
				break;
		}
		
		lexer.Read_Char();
		return tok;
	}
}