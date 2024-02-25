function Lexer(input_str) constructor{
	input = input_str;
	position = 1; //string indexing starts at 1
	read_position = 1;
	ch = 0;
	
	Read_Char = function(){
		if(read_position > string_length(input)) ch = 0;
		else ch = string_char_at(input, read_position);
		
		position = read_position;
		read_position++;
	}
	
	Read_Char();
	
	Next_Token = function(){
		
		var tok;
		
		Skip_Whitespace();
		
		switch(ch){
			case ";":
				tok = new Token(TOKEN.SEMICOLON, ch);
				break;
			case "(":
				tok = new Token(TOKEN.LPAREN, ch);
				break;
			case ")":
				tok = new Token(TOKEN.RPAREN, ch);
				break;
			case "{":
				tok = new Token(TOKEN.LBRACE, ch);
				break;
			case "}":
				tok = new Token(TOKEN.RBRACE, ch);
				break;
			case ",":
				tok = new Token(TOKEN.COMMA, ch);
				break;
			case "=":
				if(Peek_Char() == "="){
					var char = ch;
					Read_Char();
					tok = new Token(TOKEN.EQ, char + ch)
				}else{
					tok = new Token(TOKEN.ASSIGN, ch);
				}
				break;
			case "+":
				tok = new Token(TOKEN.PLUS, ch);
				break;
			case "-":
				tok = new Token(TOKEN.MINUS, ch);
				break;
			case "!":
				if(Peek_Char() == "="){
					var curr_ch = ch;
					Read_Char();
					tok = new Token(TOKEN.NOT_EQ, curr_ch+ch);
					
				} else{
					tok = new Token(TOKEN.BANG, ch);
				}
				break;
			case "*":
				tok = new Token(TOKEN.ASTERISK, ch);
				break;
			case "/":
				tok = new Token(TOKEN.SLASH, ch);
				break;
			case ">":
				tok = new Token(TOKEN.GT, ch);
				break;
			case "<":
				tok = new Token(TOKEN.LT, ch);
				break;
			case 0:
				if(!is_string(ch)){
					tok = new Token(TOKEN.EOF, "");
					break;
				}
			default:			
				if(Is_Letter(ch)){
					tok = new Token();
					tok.literal = Read_Identifier();
					tok.type = tok.Lookup_Ident(tok.literal);
					return tok;
				} else if(Is_Digit(ch)){
					tok = new Token(TOKEN.INT, Read_Number());
					return tok;
				} else{
					tok = new Token(TOKEN.ILLEGAL, ch);
				}
				break;
		}
		
		Read_Char();
		
		return tok;
	}
	
	Read_Identifier = function(){
		var start_pos = position;
		
		while(Is_Letter(ch)){
			Read_Char();	
		}
		
		return string_copy(input, start_pos, position-start_pos);
	}
	
	Is_Letter = function(char){
		if (ord(char) >= ord("a") && ord(char) <= ord("z"))
			|| (ord(char) >= ord("A") && ord(char) <= ord("Z")) return true;
        
		return false;
	}
	
	Is_Digit = function(char){
		if (ord(char) >= ord("0") && ord(char) <= ord("9")) return true;
		
		return false;
	}
	
	Skip_Whitespace = function(){
		while(ch == " " || ch == "\t" || ch == "\n" || ch == "\r") Read_Char();
	}
	
	Peek_Char = function(){
		if(read_position >= string_length(input)) return 0;
		
		return string_char_at(input, read_position);
	}
	
	Read_Number = function(){
		var start_pos = position;
		
		while(is_string(ch) && Is_Digit(ch)){
			Read_Char();	
		}
		
		return string_copy(input, start_pos, position-start_pos);
	}
}