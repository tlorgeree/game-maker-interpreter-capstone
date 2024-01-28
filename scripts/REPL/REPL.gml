function Repl(str_arr) constructor{
	var tokens = [];
	var literals = [];
	
	for(var line = 0; line < array_length(str_arr); line++){
		var lexer = new Lexer(str_arr[line]);
		
		for(var tok = lexer.Next_Token(); tok.type != TOKEN.EOF; tok = lexer.Next_Token()){
			array_push(tokens, global.token_debug_str[tok.type]);
			array_push(literals, tok.literal);
		}		
	}
	
	show_debug_message(tokens);
	show_debug_message(literals);
}