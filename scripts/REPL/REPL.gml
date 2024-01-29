function Repl(str_arr) constructor{
	input = str_arr;
	tokens = [];
	literals = [];
	
	Start = function(){
		for(var line = 0; line < array_length(input); line++){
			
			var lexer = new Lexer(input[line]);
		
			for(var tok = lexer.Next_Token(); tok.type != TOKEN.EOF; tok = lexer.Next_Token()){
				array_push(tokens, global.token_debug_str[tok.type]);
				array_push(literals, tok.literal);
			}		
		}
		
		show_debug_message(tokens);
		show_debug_message(literals);
	}
	
	
}